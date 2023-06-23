# Part of github.com/divnix/digga
#
# MIT LICENSE
# https://github.com/divnix/digga/blob/17713c22d07c54525c728c62060a0428b76dee3b/COPYING
_: {
  flattenTree =
    /*
    *
    Synopsis: flattenTree _tree_

    Flattens a _tree_ of the shape that is produced by rakeLeaves.

    Output Format:
    An attrset with names in the spirit of the Reverse DNS Notation form
    that fully preserve information about grouping from nesting.

    Example input:
    ```
    {
    a = {
    b = {
    c = <path>;
    };
    };
    }
    ```

    Example output:
    ```
    {
    "a.b.c" = <path>;
    }
    ```
    *
    */
    tree: let
      op = sum: path: val: let
        pathStr = builtins.concatStringsSep "." path; # dot-based reverse DNS notation
      in
        if builtins.isPath val
        then
          # builtins.trace "${toString val} is a path"
          (sum
            // {
              "${pathStr}" = val;
            })
        else if builtins.isAttrs val
        then
          # builtins.trace "${builtins.toJSON val} is an attrset"
          # recurse into that attribute set
          (recurse sum path val)
        else
          # ignore that value
          # builtins.trace "${toString path} is something else"
          sum;
      recurse = sum: path: val:
        builtins.foldl'
        (sum: key: op sum (path ++ [key]) val.${key})
        sum
        (builtins.attrNames val);
    in
      recurse {} [] tree;
}
