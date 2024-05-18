function [fire, transition] = MOD_ct_PRE (transition)

fire = 1;

switch transition.name
    case 'tCTLoadCTN'
        % Get IDs from previous places
        token_ids_from_sa_ship_msg = tokIDs('pSAShipMsgToCT');
        token_ids_from_sa_manifest = tokIDs('pSAManifestToCT');
        token_ids_from_depot = tokIDs('pDepotOutboundCTNToCT');
        
        % If three tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_sa_ship_msg)
            token_id_from_sa_ship_msg = token_ids_from_sa_ship_msg(i);
            colors = get_color('pSAShipMsgToCT', ...
                token_id_from_sa_ship_msg);
            color_of_sa_ship_msg_token = colors{1};

            for j = 1 : numel(token_ids_from_sa_manifest)
                token_id_from_sa_manifest = token_ids_from_sa_manifest(j);
                colors = get_color('pSAManifestToCT', token_id_from_sa_manifest);
                color_of_sa_manifest_token = colors{1};

                for k = 1 : numel(token_ids_from_depot)
                    token_id_from_depot = token_ids_from_depot(k);
                    colors = get_color('pDepotOutboundCTNToCT', token_id_from_depot);
                    color_of_sa_token = colors{1};

                    if strcmp(color_of_sa_ship_msg_token, ...
                        color_of_sa_manifest_token) && ...
                            strcmp(color_of_sa_ship_msg_token, color_of_sa_token)
                        matching_tokens(end+1,:) = [token_ids_from_sa_ship_msg, ...
                            token_id_from_sa_manifest, token_id_from_depot];
                    end
                end
            end
        end
        if ~isempty(matching_tokens)
            transition.selected_tokens = matching_tokens;
            fire = 1;
        else
            fire = 0;
        end
    case 'tCTGetClearance'
        % Get IDs from previous places
        token_ids_from_customs = tokIDs('pCustomsClearanceToCT');
        token_ids_from_ct = tokIDs('pCTArrivalMsgSent');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_customs)
            token_id_from_customs = token_ids_from_customs(i);
            colors = get_color('pCustomsClearanceToCT', ...
                token_id_from_customs);
            color_of_customs_token = colors{1};

            for j = 1 : numel(token_ids_from_ct)
                token_id_from_ct = token_ids_from_ct(j);
                colors = get_color('pCTArrivalMsgSent', token_id_from_ct);
                color_of_ct_token = colors{1};
                
                if strcmp(color_of_customs_token, color_of_ct_token)
                    matching_tokens(end+1,:) = [token_id_from_customs, ...
                        token_id_from_ct];
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