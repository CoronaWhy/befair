#    $(if ($(realpath )) \
#    )\
comma := ,
eq = $(and $(findstring $(1),$(2)),$(findstring $(2),$(1)))

# Search and include in parent directories files
# As second parameter, optional can be given 'include' prefix. For example:
# If '-' will be given, it will be added to '-include', which will make
# include do not fail if there is no .mk file.
include-parent-mk = \
    $(if $(call eq,$(abspath $(CURDIR)/$1),$(abspath $(CURDIR)/../$1)), \
        $(error Can't find "$1" in parent directory) \
    ) \
    $(if $(wildcard $(CURDIR)/$1), \
        $(eval $(2)include $(CURDIR)/$1)\
        ,\
        $(call include-parent-mk,../$1,$2)\
    )

search-parent-mk = \
    $(if $(call eq,$(abspath $(CURDIR)/$1),$(abspath $(CURDIR)/../$1)),, \
        $(if $(wildcard $(CURDIR)/$1), \
            $(abspath $(CURDIR)/$1)\
            ,\
            $(call search-parent-mk,../$1)\
        ) \
    )

$(call include-parent-mk,mk/helpers.mk)
$(call include-parent-mk,mk/common.mk)

