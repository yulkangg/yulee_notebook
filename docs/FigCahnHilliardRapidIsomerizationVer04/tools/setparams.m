function pkg = setparams(default_params,current_params)
pkg = default_params; 

fields = fieldnames(current_params);

for i = 1:numel(fields) % Loop over fields and concatenate names and values
    field_name = fields{i};
    pkg.(field_name) = current_params.(field_name);
    if isfield(default_params,field_name)
        if pkg.(field_name) ~= default_params.(field_name)
            disp(['Using non-default value for ' field_name])
        end
    else
        disp(['Note: The field `' field_name '` in current_params has no corresponding default value.'])
    end
end

end



 