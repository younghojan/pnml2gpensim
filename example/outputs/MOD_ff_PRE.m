function [fire, transition] = MOD_ff_PRE (transition)

fire = 1;

switch transition.name
    case 'tFFGetManifest'
        % Get IDs from previous places
        token_ids_from_ff_order_sent = tokIDs('pFFOrderSent');
        token_ids_from_ff_so_sent = tokIDs('pFFSOSent');
        token_ids_from_sa = tokIDs('pSAManifestToFF');
        
        % If three tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_ff_order_sent)
            token_id_from_ff_order_sent = token_ids_from_ff_order_sent(i);
            colors = get_color('pFFOrderSent', token_id_from_ff_order_sent);
            color_of_ff_order_sent_token = colors{1};

            for j = 1 : numel(token_ids_from_ff_so_sent)
                token_id_from_ff_so_sent = token_ids_from_ff_so_sent(j);
                colors = get_color('pFFSOSent', token_id_from_ff_so_sent);
                color_of_ff_so_sent_token = colors{1};

                for k = 1 : numel(token_ids_from_sa)
                    token_id_from_sa = token_ids_from_sa(k);
                    colors = get_color('pSAManifestToFF', token_id_from_sa);
                    color_of_sa_token = colors{1};

                    if strcmp(color_of_ff_order_sent_token, ...
                            color_of_ff_so_sent_token) && ...
                            strcmp(color_of_ff_so_sent_token, color_of_sa_token)
                        matching_tokens(end+1,:) = [token_id_from_ff_order_sent, ...
                            token_id_from_ff_so_sent, ...
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
    case 'tFFSendReceipt'
        % Get IDs from previous places
        token_ids_from_ff = tokIDs('pFFManifestReceived');
        token_ids_from_sa = tokIDs('pSAReceiptToFF');
        
        % If two tokens have the same color (which means they are the same 
        % batch of goods or from the same company , or anything)
        matching_tokens = [];
        for i = 1 : numel(token_ids_from_ff)
            token_id_from_ff = token_ids_from_ff(i);
            colors = get_color('pFFManifestReceived', token_id_from_ff);
            color_of_ff_token = colors{1};

            for j = 1 : numel(token_ids_from_sa)
                token_id_from_sa = token_ids_from_sa(j);
                colors = get_color('pSAReceiptToFF', token_id_from_sa);
                color_of_sa_token = colors{1};

                if strcmp(color_of_ff_token, color_of_sa_token) 
                    matching_tokens(end+1,:) = [token_id_from_ff, ...
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