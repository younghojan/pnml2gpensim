function [fire, transition] = MOD_transport_PRE (transition)

fire = 1;

switch transition.name
    case 'tTransportSendCTN'
        % Get IDs from previous places
        token_ids_from_ff = tokIDs('pFFReceiptToTransport');
        token_ids_from_depot = tokIDs('pDepotEmptyCTNToTransport');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_ff)
            token_id_from_ff = token_ids_from_ff(i);
            colors = get_color('pFFReceiptToTransport', ...
                token_id_from_ff);
            color_of_ff_token = colors{1};

            for j = 1 : numel(token_ids_from_depot)
                token_id_from_depot = token_ids_from_depot(j);
                colors = get_color('pDepotEmptyCTNToTransport', ...
                    token_id_from_depot);
                color_of_depot_token = colors{1};
                
                if strcmp(color_of_ff_token, color_of_depot_token)
                    matching_tokens(end+1,:) = [token_id_from_ff, ...
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
    case 'tTransportGetOutboundCTN'
        % Get IDs from previous places
        token_ids_from_owner = tokIDs('pOwnerCTNToTransport');
        token_ids_from_transport = tokIDs('pTransportCTNSent');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_owner)
            token_id_from_owner = token_ids_from_owner(i);
            colors = get_color('pOwnerCTNToTransport', ...
                token_id_from_owner);
            color_of_owner_token = colors{1};

            for j = 1 : numel(token_ids_from_transport)
                token_id_from_transport = token_ids_from_transport(j);
                colors = get_color('pTransportCTNSent', ...
                    token_id_from_transport);
                color_of_transport_token = colors{1};
                
                if strcmp(color_of_owner_token, color_of_transport_token)
                    matching_tokens(end+1,:) = [token_id_from_owner, ...
                        token_id_from_transport];
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