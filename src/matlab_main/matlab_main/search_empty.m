function data = search_empty(data)
% function that takes in a struct searches for empty values within

names = fieldnames(data);

delList = [];
for i = 1:size(data, 2)
    for j = 1:length(names)
        if isempty(getfield(data(i), names(j)))
            delList = [delList i]
        end
    end
end

delList = unique(delList);
data(delList) = [];


    