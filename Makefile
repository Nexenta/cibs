# For bootstrapping:
cibs-root := .

# Define to "deb" to build a deb package:
# gmake package=deb
package ?= ips

# This is it forever ever:
cibs-inst-root := /usr/share/cibs

include $(cibs-root)/rules/$(package).mk

name := cibs
version := 0.3.0.2

install-stamp: rules-mogrify-stamp

# Replace $(cibs-root) -> /usr/share/cibs
rules-mogrify-stamp:
	mkdir -p mogrified/rules
	for r in $(cibs-root)/rules/*.mk; do \
		echo "Mogrifying $$r ..."; \
		sed -e 's,$$(cibs-root),$(cibs-inst-root),g' \
		$$r > mogrified/rules/`basename $$r`; \
	done
	touch $@

clean::
	rm -rf mogrified

