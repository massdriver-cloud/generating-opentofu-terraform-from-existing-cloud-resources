.PHONY: reset

reset:
	-rm module/{generated.tf,terraform.tfstate,terraform.tfstate.backup,.terraform.lock.hcl}
	echo "" > module/import.tf
	cd module && tofu init
