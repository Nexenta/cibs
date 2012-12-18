#!/bin/sh

cat <<META
set name=pkg.fmri value=pkg:/developer/pkg/cibs@0.1.0
set name=pkg.summary value="Common IPS build system"
set name=info.upstream-url value="https://github.com/Nexenta/cibs"
set name=info.source-url value="https://github.com/Nexenta/cibs.git"

license LICENSE license=CDDL

depend fmri=pkg:/developer/build/gnu-make type=require

META

echo '# rules:'
for r in mogrified/rules/*.mk; do
    echo "file $r path=\$(cibs-inst-root)/rules/`basename $r`"
done

echo
echo '# scripts:'
for s in scripts/*; do
    if ! [ -f "$s" ]; then
        echo "Garbage in scripts: \`$s'" >&2
        exit 1
    fi
    if ! [ -x "$s" ]; then
        echo "\`$s' is not executable" >&2
        exit 1
    fi
    echo "file $s path=\$(cibs-inst-root)/scripts/`basename $s` mode=0555"
done

echo
echo '# transformations:'
for t in trans/*; do
    if ! [ -f "$t" ]; then
        echo "Garbage in trans: \`$t'" >&2
        exit 1
    fi
    echo "file $t path=\$(cibs-inst-root)/trans/`basename $t`"
done

