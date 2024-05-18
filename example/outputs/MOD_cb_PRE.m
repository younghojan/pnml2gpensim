function [fire, transition] = MOD_cb_PRE (transition)

fire = 1;

switch transition.name
    case 'tCBAppoint'
        % Get IDs from previous places
        token_ids_from_customs = tokIDs('pCustomsDeclarationToCB');
        token_ids_from_cb = tokIDs('pCBDeclared');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_customs)
            token_id_from_customs = token_ids_from_customs(i);
            colors = get_color('pCustomsDeclarationToCB', ...
                token_id_from_customs);
            color_of_customs_token = colors{1};

            for j = 1 : numel(token_ids_from_cb)
                token_id_from_cb = token_ids_from_cb(j);
                colors = get_color('pCBDeclared', token_id_from_cb);
                color_of_cb_token = colors{1};
                
                if strcmp(color_of_customs_token, color_of_cb_token)
                    matching_tokens(end+1,:) = [token_id_from_customs, ...
                        token_id_from_cb];
                end
            end
        end
        if ~isempty(matching_tokens)
            transition.selected_tokens = matching_tokens;
            fire = 1;
        else
            fire = 0;
        end
    case 'tCBGetClearance'
        % Get IDs from previous places
        token_ids_from_customs = tokIDs('pCustomsClearanceToCB');
        token_ids_from_cb = tokIDs('pCBAppointed');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_customs)
            token_id_from_customs = token_ids_from_customs(i);
            colors = get_color('pCustomsClearanceToCB', ...
                token_id_from_customs);
            color_of_customs_token = colors{1};

            for j = 1 : numel(token_ids_from_cb)
                token_id_from_cb = token_ids_from_cb(j);
                colors = get_color('pCBAppointed', token_id_from_cb);
                color_of_cb_token = colors{1};
                
                if strcmp(color_of_customs_token, color_of_cb_token)
                    matching_tokens(end+1,:) = [token_id_from_customs, ...
                        token_id_from_cb];
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