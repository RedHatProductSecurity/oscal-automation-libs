############################################################################
## Assemble OSCAL content
############################################################################

create-ssp:
	@source $(scripts_dir)/create.sh && create-ssp
.PHONY: create-ssp