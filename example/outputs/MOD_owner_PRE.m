function [fire, transition] = MOD_owner_PRE (transition)

global global_info

fire = 1;

switch transition.name
    case 'tTokenShader'
        if global_info.CURRENT_TOKEN <= global_info.MAX_TOKENS_NUM
            color = num2str(global_info.CURRENT_TOKEN);
            global_info.CURRENT_TOKEN = global_info.CURRENT_TOKEN + 1;
            transition.new_color = color;
            transition.override = 1;
        else
            fire = 0;
        end
    case 'tOwnerSendCTN'
        % Get IDs from previous places
        token_ids_from_transport = tokIDs('pTransportCTNToOwner');
        token_ids_from_owner = tokIDs('pOwnerOrderSent');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_transport)
            token_id_from_transport = token_ids_from_transport(i);
            colors = get_color('pTransportCTNToOwner', ...
                token_id_from_transport);
            color_of_transport_token = colors{1};

            for j = 1 : numel(token_ids_from_owner)
                token_id_from_owner = token_ids_from_owner(j);
                colors = get_color('pOwnerOrderSent', ...
                    token_id_from_owner);
                color_of_owner_token = colors{1};
                
                if strcmp(color_of_transport_token, color_of_owner_token)
                    matching_tokens(end+1,:) = [token_id_from_transport, ...
                        token_id_from_owner];
                end
            end
        end
        if ~isempty(matching_tokens)
            transition.selected_tokens = matching_tokens;
            fire = 1;
        else
            fire = 0;
        end
    case 'tOwnerGetExpenseNote'
        % Get IDs from previous places
        token_ids_from_SA = tokIDs('pSAExpenseNoteToOwner');
        token_ids_from_owner = tokIDs('pOwnerCTNSent');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_SA)
            token_id_from_SA = token_ids_from_SA(i);
            colors = get_color('pSAExpenseNoteToOwner', ...
                token_id_from_SA);
            color_of_transport_token = colors{1};

            for j = 1 : numel(token_ids_from_owner)
                token_id_from_owner = token_ids_from_owner(j);
                colors = get_color('pOwnerCTNSent', ...
                    token_id_from_owner);
                color_of_owner_token = colors{1};
                
                if strcmp(color_of_transport_token, color_of_owner_token)
                    matching_tokens(end+1,:) = [token_id_from_SA, ...
                        token_id_from_owner];
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