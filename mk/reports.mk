############################################################################
## Generate reports for gap analysis activities
############################################################################

scripts_dir :=$(shell realpath $(dir $(lastword $(MAKEFILE_LIST)))../scripts)


# $1 - input ssp
# $2 - profile name
# $3 - template
define gap-report
	@source $(scripts_dir)/trestle.sh && trestle author ssp-filter --name $(1) -o filtered_ssp -co "system-specific" -is "planned" \
	&& trestle author jinja -i $(3) -ssp filtered_ssp -p $(2) -o gap-report.md
endef

# $1 - input ssp
# $2 - profile name
# $3 - template
define customer-report
	@source $(scripts_dir)/trestle.sh && trestle author ssp-filter --name $(1) -o "crm_ssp" -co "customer-configured,customer-provided" \
	&& trestle author jinja -i $(3) -ssp crm_ssp -p $(2) -o customer-report.md
endef


