define check_var
ifndef $(1)
	$(error please set the variable in your arch file)
endif
endef