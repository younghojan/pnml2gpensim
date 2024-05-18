function [fire, transition] = MOD_depot_PRE (transition)

fire = 1;

switch transition.name
    case 'tDepotGetOutboundAndReceipt'
        % Get IDs from previous places
        token_ids_from_transport = tokIDs('pTransportOutboundAndReceiptToDepot');
        token_ids_from_depot = tokIDs('pDepotInfoSent');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_transport)
            token_id_from_transport = token_ids_from_transport(i);
            colors = get_color('pTransportOutboundAndReceiptToDepot', ...
                token_id_from_transport);
            color_of_transport_token = colors{1};

            for j = 1 : numel(token_ids_from_depot)
                token_id_from_depot = token_ids_from_depot(j);
                colors = get_color('pDepotInfoSent', token_id_from_depot);
                color_of_depot_token = colors{1};
                
                if strcmp(color_of_transport_token, color_of_depot_token)
                    matching_tokens(end+1,:) = [token_id_from_transport, ...
                        token_id_from_depot];
                end
            end
        end
        if ~isempty(matching_tokens)
            transition.selected_tokens = matching_tokens;
            fire = 1;
        else
            fire = 0;
        end
end