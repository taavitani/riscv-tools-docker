IMAGE := taavitani/riscv-tools
TAG := latest

DOTFILE_IMAGE = $(subst /,_,$(IMAGE))-$(TAG)

all: build

build: .image-$(DOTFILE_IMAGE) image-name
.image-$(DOTFILE_IMAGE): Dockerfile
	@docker build \
	-t $(IMAGE):$(TAG) \
	-f Dockerfile \
	.
	@docker images -q $(IMAGE):$(TAG) > $@

image-name:
	@echo "image: $(IMAGE):$(TAG)"
