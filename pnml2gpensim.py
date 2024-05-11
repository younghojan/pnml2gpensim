import xml.etree.ElementTree as ET

# List of known module names used throughout the program for processing.
MODULE_NAMES = [
    "Owner",
    "CT",
    "CB",
    "Customs",
    "Depot",
    "FF",
    "SBGS",
    "SA",
    "Transport",
    "Collect",
]


def load_xml(file_path):
    """
    Attempts to load and parse an XML file from the specified file path.
    Returns the root element of the XML tree or None if an error occurs.
    """
    try:
        tree = ET.parse(file_path)
        return tree.getroot()
    except ET.ParseError as e:
        print(f"Error parsing the XML file: {e}")
        return None
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return None


def find_elements_by_tag_and_prefix(root, tag, prefix):
    """
    Searches for XML elements by tag name, filtering elements whose
    associated text starts with a specified prefix.
    Returns a list of dictionaries containing element IDs, names,
    and module names if found.
    """
    elements = []
    for element in root.findall(f".//{tag}"):
        name = (
            element.find(".//text").text
            if element.find(".//text") is not None
            else None
        )
        module = None
        if name is not None:
            for m in MODULE_NAMES:
                if name.startswith(prefix + m, name.find(prefix)):
                    module = m
                    break
        elements.append({"id": element.get("id"), "name": name, "module": module})
    return elements


def find_arcs(root):
    """
    Extracts all 'arc' elements from the XML, returning a list of dictionaries
    with source and target IDs.
    """
    return [
        {"source_id": arc.get("source"), "target_id": arc.get("target")}
        for arc in root.findall(".//arc")
    ]


def identify_intermodule_connectors(places, transitions, arcs):
    """
    Identifies intermodule connectors between places and transitions.
    Returns lists of intermodule connectors (IMCs) and input/output ports (IO_ports).
    """
    places_dict = {place["id"]: place for place in places}
    transitions_dict = {transition["id"]: transition for transition in transitions}
    IMCs = []
    IO_ports = []

    for arc in arcs:
        source, target = arc["source_id"], arc["target_id"]
        if (
            source in places_dict
            and target in transitions_dict
            and (
                places_dict[source]["module"]
                != transitions_dict[target]["module"]
                != "Collect"
            )
        ):
            IMCs.append(places_dict[source])
            connected_arcs = [
                transitions_dict[a["source_id"]]
                for a in arcs
                if a["target_id"] == source
            ]
            for arc in connected_arcs:
                if arc not in IO_ports:
                    IO_ports.append(arc)

            if transitions_dict[target] not in IO_ports:
                IO_ports.append(transitions_dict[target])

    return IMCs, IO_ports


def write_arcs(f, arcs, places, transitions, module, IMCs):
    """
    Writes the arcs data to the file with specified formatting and conditions, optimized for simplicity and efficiency.
    """
    # Pre-compute IMC names and maps for quick lookup
    imc_names = {imc["name"] for imc in IMCs}
    place_map = {
        place["id"]: place["name"]
        for place in places
        if place["module"] == module and place["name"] not in imc_names
    }
    transition_map = {
        transition["id"]: transition["name"]
        for transition in transitions
        if transition["module"] == module
    }

    # Generate formatted arc lines
    arc_lines = []
    for arc in arcs:
        source_place = place_map.get(arc["source_id"])
        target_transition = transition_map.get(arc["target_id"])
        source_transition = transition_map.get(arc["target_id"])
        target_place = place_map.get(arc["source_id"])

        if source_place and target_transition:
            arc_lines.append(f"'{source_place}', '{target_transition}', 1, ...")
        elif source_transition and target_place:
            arc_lines.append(f"'{source_transition}', '{target_place}', 1")

    if formatted_arc_lines := ", ...\n\t".join(arc_lines):
        f.write("pns.set_of_As = {\n\t")
        f.write(formatted_arc_lines)
        f.write("\n\t};\n\n")


def write_names(f, names, set_name):
    if names:
        f.write(f"pns.{set_name} = {{\n\t")
        formatted_names = ", ...\n\t".join(names)
        f.write(formatted_names)
        f.write("\n\t};\n\n")


def write_places_and_transitions(f, places, transitions, module, IMCs):
    """
    Writes the places and transitions data to the file with specified formatting and conditions.
    """
    imc_names = {imc["name"] for imc in IMCs}

    places_names = [
        f"'{place['name']}'"
        for place in places
        if place["name"] is not None
        and place["module"] == module
        and place["name"] not in imc_names
    ]
    transitions_names = [
        f"'{transition['name']}'"
        for transition in transitions
        if transition["name"] is not None and transition["module"] == module
    ]

    write_names(f, places_names, "set_of_Ps")
    write_names(f, transitions_names, "set_of_Ts")


def write_header(f, module):
    f.write(f"function [pns] = {module.lower()}_pdf()\n\n")
    f.write(f"pns.PN_name = '{module}';\n\n")


def write_io_ports(f, io_ports, module):
    if io_ports_names := [
        f"'{io_port['name']}'"
        for io_port in io_ports
        if io_port["name"] is not None and io_port["module"] == module
    ]:
        f.write("pns.set_of_ports = {\n\t")
        formatted_io_ports_names = ", ...\n\t".join(io_ports_names)
        f.write(formatted_io_ports_names)
        f.write("\n\t};\n\n")


if __name__ == "__main__":
    root = load_xml("./woped_net.pnml")
    if root is not None:
        # Parse the elements
        places = find_elements_by_tag_and_prefix(root, "place", "p")
        transitions = find_elements_by_tag_and_prefix(root, "transition", "t")
        arcs = find_arcs(root)
        IMCs, IO_ports = identify_intermodule_connectors(places, transitions, arcs)

        # Write *_pdf.m files
        for module in MODULE_NAMES:
            with open(f"{module.lower()}_pdf.m", "w") as f:
                # Write the function header
                write_header(f, module)

                # Write the places and transitions
                write_places_and_transitions(f, places, transitions, module, IMCs)

                # Write the transitions
                write_arcs(f, arcs, places, transitions, module, IMCs)

                # Write the IO ports
                write_io_ports(f, IO_ports, module)

    print("Done!")
