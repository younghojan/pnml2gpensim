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
    return [
        {
            "id": element.get("id"),
            "name": (
                name := (
                    element.find(".//text").text
                    if element.find(".//text") is not None
                    else None
                )
            ),
            "module": next(
                (
                    m
                    for m in MODULE_NAMES
                    if name and name.startswith(prefix + m, name.find(prefix))
                ),
                None,
            ),
        }
        for element in root.findall(f".//{tag}")
    ]


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
        if source in places_dict and target in transitions_dict:
            if (
                places_dict[source]["module"] != transitions_dict[target]["module"]
                and transitions_dict[target]["module"] != "Collect"
            ):
                IMCs.append(places_dict[source])
                transitions = [
                    transitions_dict[a["source_id"]]
                    for a in arcs
                    if a["target_id"] == source
                ]
                for transition in transitions:
                    if transition not in IO_ports:
                        IO_ports.append(transition)

                if transitions_dict[target] not in IO_ports:
                    IO_ports.append(transitions_dict[target])

    return IMCs, IO_ports


def write_arcs(file, arcs, places, transitions, module, IMCs):
    """
    Writes the arcs data to the file in a specific format, optimized for simplicity and efficiency.
    It filters places and transitions by module and excludes places that are named after IMCs.
    """
    # Create sets for quick lookup
    imc_names = {imc["name"] for imc in IMCs}

    # Filter and map places and transitions by module
    place_map = {
        p["id"]: p["name"]
        for p in places
        if p["module"] == module and p["name"] not in imc_names
    }
    transition_map = {t["id"]: t["name"] for t in transitions if t["module"] == module}

    # Collect formatted arc lines using a set to avoid duplicates
    arc_lines = set()
    for arc in arcs:
        source = place_map.get(arc["source_id"])
        target = transition_map.get(arc["target_id"])
        if source and target:
            arc_lines.add(f"'{source}', '{target}', 1")

        # Check reverse roles and conditional arcs within the same module
        source_transition = transition_map.get(arc["target_id"])
        target_place_ids = {
            a["target_id"] for a in arcs if a["source_id"] == arc["target_id"]
        }

        for target_id in target_place_ids:
            if target_id in place_map and target_id != arc["source_id"]:
                arc_lines.add(f"'{source_transition}', '{place_map[target_id]}', 1")

    # Convert set to sorted list for consistent order, then format for writing
    if arc_lines:
        formatted_arc_lines = ", ...\n\t".join(sorted(list(arc_lines)))
        file.write(f"png.set_of_As = {{\n\t{formatted_arc_lines}\n\t}};\n\n")


def write_places_and_transitions(f, places, transitions, module, IMCs):
    """
    Writes the places and transitions data to the file with specified formatting and conditions.
    """
    # Pre-compute IMC names for quick lookup
    imc_names = {imc["name"] for imc in IMCs}

    # Generate formatted names list of places and transitions meeting the conditions
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

    # Write to file if there are any eligible places
    if places_names:
        f.write("png.set_of_Ps = {\n\t")
        formatted_places_names = ", ...\n\t".join(places_names)
        f.write(formatted_places_names)
        f.write("\n\t};\n\n")

    # Write to file if there are any eligible transitions
    if transitions_names:
        f.write("png.set_of_Ts = {\n\t")
        formatted_transitions_names = ", ...\n\t".join(transitions_names)
        f.write(formatted_transitions_names)
        f.write("\n\t};\n\n")


def write_header(f, module):
    f.write(f"function [png] = {module.lower()}_pdf()\n\n")
    f.write(f"png.PN_name = '{module.lower()}';\n\n")


def write_io_ports(f, io_ports, module):
    io_ports_names = [
        f"'{io_port['name']}'"
        for io_port in io_ports
        if io_port["name"] is not None and io_port["module"] == module
    ]
    if io_ports_names:
        f.write("png.set_of_Ports = {\n\t")
        formatted_io_ports_names = ", ...\n\t".join(io_ports_names)
        f.write(formatted_io_ports_names)
        f.write("\n\t};\n\n")


def write_imcs(f, arcs, IMCs, transitions):
    if IMCs_names := [f"'{IMC['name']}'" for IMC in IMCs if IMC["name"] is not None]:
        f.write("png.set_of_Ps = {\n\t")
        formatted_IMCs_names = ", ...\n\t".join(IMCs_names)
        f.write(formatted_IMCs_names)
        f.write("\n\t};\n\n")

        place_map = {IMC["id"]: IMC["name"] for IMC in IMCs}
        transition_map = {
            transition["id"]: transition["name"] for transition in transitions
        }

        arc_lines = set()
        for arc in arcs:
            source = place_map.get(arc["source_id"])
            target = transition_map.get(arc["target_id"])
            if source and target:
                arc_lines.add(f"'{source}', '{target}', 1")

            # Check reverse roles and conditional arcs within the same module
            source_transition = transition_map.get(arc["target_id"])
            target_place_ids = {
                a["target_id"] for a in arcs if a["source_id"] == arc["target_id"]
            }

            for target_id in target_place_ids:
                if target_id in place_map and target_id != arc["source_id"]:
                    arc_lines.add(f"'{source_transition}', '{place_map[target_id]}', 1")

        # Convert set to sorted list for consistent order, then format for writing
        if arc_lines:
            formatted_arc_lines = ", ...\n\t".join(sorted(list(arc_lines)))
            f.write(f"png.set_of_As = {{\n\t{formatted_arc_lines}\n\t}};\n\n")


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

        # Write IMC_pdf.m file
        with open("imc_pdf.m", "w") as f:
            write_header(f, "imc")
            write_imcs(f, arcs, IMCs, transitions)

    print("Done!")
