function str = paramstr(par,precision)
fields = fieldnames(par);
str = '';
for i = 1:numel(fields) % Loop over fields and concatenate names and values
    field_name = fields{i};
    field_value = par.(field_name);
    if isnumeric(field_value)  % Convert the field value to a string representation
        value_str = mat2str(field_value,precision); % Convert numeric values to string
    elseif ischar(field_value)
        value_str = ['''' field_value '''']; % Enclose char arrays in quotes
    else
        error('paramstr() says: field value of unknown type.')
    end
    str = [str, '-', field_name, '=', value_str ]; % Concatenate field name and value
end
end



 