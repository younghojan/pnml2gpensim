function [fire, transition] = MOD_sa_PRE (transition)

fire = 1;

switch transition.name
    case 'tSAGetCTNInfo'
        % Get IDs from previous places
        token_ids_from_depot = tokIDs('pDepotCTNInfoToSA');
        token_ids_from_sa = tokIDs('pSAAsked');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_depot)
            token_id_from_depot = token_ids_from_depot(i);
            colors = get_color('pDepotCTNInfoToSA', token_id_from_depot);
            color_of_depot_token = colors{1};

            for j = 1 : numel(token_ids_from_sa)
                token_id_from_sa = token_ids_from_sa(j);
                colors = get_color('pSAAsked', token_id_from_sa);
                color_of_sa_token = colors{1};
                
                if strcmp(color_of_depot_token, color_of_sa_token)
                    matching_tokens(end+1,:) = [token_id_from_depot, ...
                        token_id_from_sa];
                end
            end
        end
        if ~isempty(matching_tokens)
            transition.selected_tokens = matching_tokens;
            fire = 1;
        else
            fire = 0;
        end
    case 'tSAWaitShipDeparture'
        % Get IDs from previous places
        token_ids_from_ct = tokIDs('pCTDepartureInfoToSA');
        token_ids_from_sa = tokIDs('pSACrewListMade');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_ct)
            token_id_from_ct = token_ids_from_ct(i);
            colors = get_color('pCTDepartureInfoToSA', token_id_from_ct);
            color_of_ct_token = colors{1};

            for j = 1 : numel(token_ids_from_sa)
                token_id_from_sa = token_ids_from_sa(j);
                colors = get_color('pSACrewListMade', token_id_from_sa);
                color_of_sa_token = colors{1};
                
                if strcmp(color_of_ct_token, color_of_sa_token)
                    matching_tokens(end+1,:) = [token_id_from_ct, ...
                        token_id_from_sa];
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