.PHONY: notebook chat requirements prepare train activate download clean

ACTIVATE=python3 -m venv .venv && . .venv/bin/activate && pip install --upgrade pip

# comment one of these definitions and uncomment the other:
#DOWNLOAD_OR_TRAIN=download
DOWNLOAD_OR_TRAIN=train

notebook:
	python3 tools/make_colab.py

chat: data/tokenizer.json checkpoints/best_model.pt checkpoints/config.json requirements
	$(ACTIVATE) && python -m guppylm $@

data/tokenizer.json checkpoints/best_model.pt checkpoints/config.json:
	make $(DOWNLOAD_OR_TRAIN)

prepare: requirements
	$(ACTIVATE) && python -m guppylm $@

train: prepare
	$(ACTIVATE) && python -m guppylm $@

requirements: requirements.txt
	pip install -r $^

activate:
	python3 -m venv .venv
	echo "Virtual environment ready. Now you can active it with: source .venv/bin/activate"

download:
	$(ACTIVATE) && python -m guppylm $@

clean:
	- rm -rf venv data checkpoints

