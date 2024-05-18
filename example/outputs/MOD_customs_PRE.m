function [fire, transition] = MOD_customs_PRE (transition)

fire = 1;

switch transition.name
    case 'tCustomsGetAppointment'
        % Get IDs from previous places
        token_ids_from_cb = tokIDs('pCBAppointmentToCustoms');
        token_ids_from_customs = tokIDs('pCustomsDeclared');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_cb)
            token_id_from_cb = token_ids_from_cb(i);
            colors = get_color('pCBAppointmentToCustoms', token_id_from_cb);
            color_of_cb_token = colors{1};

            for j = 1 : numel(token_ids_from_customs)
                token_id_from_customs = token_ids_from_customs(j);
                colors = get_color('pCustomsDeclared', token_id_from_customs);
                color_of_customs_token = colors{1};
                
                if strcmp(color_of_cb_token, color_of_customs_token)
                    matching_tokens(end+1,:) = [token_id_from_cb, ...
                        token_id_from_customs];
                end
            end
        end
        if ~isempty(matching_tokens)
            transition.selected_tokens = matching_tokens;
            fire = 1;
        else
            fire = 0;
        end
    case 'tCustomsCIQ'
        % Get IDs from previous places
        token_ids_from_customs = tokIDs('pCustomsAppointmentReceived');
        token_ids_from_ct = tokIDs('pCTArrivalMsgToCustoms');
        token_ids_from_cb = tokIDs('pSAManifestToCustoms');
        
        % If three tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_customs)
            token_id_from_customs = token_ids_from_customs(i);
            colors = get_color('pCustomsAppointmentReceived', ...
                token_id_from_customs);
            color_of_customs_token = colors{1};

            for j = 1 : numel(token_ids_from_ct)
                token_id_from_ct = token_ids_from_ct(j);
                colors = get_color('pCTArrivalMsgToCustoms', token_id_from_ct);
                color_of_ct_token = colors{1};

                for k = 1 : numel(token_ids_from_cb)
                    token_id_from_sa = token_ids_from_cb(k);
                    colors = get_color('pSAManifestToCustoms', token_id_from_sa);
                    color_of_sa_token = colors{1};

                    if strcmp(color_of_customs_token, ...
                            color_of_ct_token) && ...
                            strcmp(color_of_ct_token, color_of_sa_token)
                        matching_tokens(end+1,:) = [token_id_from_customs, ...
                            token_id_from_ct, ...
                            token_id_from_sa];
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
end