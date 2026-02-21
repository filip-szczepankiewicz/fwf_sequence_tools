function info(pkgname)
%ROOT.INFO Print full function/class tree of the fix package.
%
% Usage:
%   root.info()              % starts at 'root' package

    if nargin == 0
        pkgname = 'fwf';
    end

    mp = meta.package.fromName(pkgname);
    if isempty(mp)
        error('Package "%s" not found on path.', pkgname);
    end

    fprintf('\n%s\n', pkgname);
    fprintf('%s\n', repmat('=', 1, strlength(pkgname)));

    printPackage(pkgname, '', true);

    fprintf('\n');
end


% =========================
% Recursive printer
% =========================
function printPackage(pkgname, indent, isRoot)

    mp = meta.package.fromName(pkgname);
    if isempty(mp), return; end

    % Collect members
    funcs   = sort({mp.FunctionList.Name});
    classes = sort({mp.ClassList.Name});
    subs    = sort({mp.PackageList.Name});

    % Hide info itself if we're at root fix
    if isRoot
        funcs(strcmp(funcs,'info')) = [];
    end

    items = [funcs, classes, cellfun(@lastToken, subs, 'UniformOutput', false)];
    types = [repmat("func",1,numel(funcs)), ...
             repmat("class",1,numel(classes)), ...
             repmat("pkg",1,numel(subs))];

    for k = 1:numel(items)

        isLast = (k == numel(items));

        if isLast
            branch = "└── ";
            nextIndent = indent + "    ";
        else
            branch = "├── ";
            nextIndent = indent + "│   ";
        end

        name = items{k};

        switch types(k)
            case "func"
                label = name;
            case "class"
                label = name;
            case "pkg"
                label = name;
        end

        fprintf('%s%s%s\n', indent, branch, label);

        % Recurse into subpackage
        if types(k) == "pkg"
            subFull = subs{k - numel(funcs) - numel(classes)};
            printPackage(subFull, nextIndent, false);
        end
    end
end


function t = lastToken(fullname)
    parts = split(string(fullname), '.');
    t = char(parts(end));
end