.PHONY: notebook chat requirements prepare train activate download clean

ACTIVATE=python3 -m venv .venv && . .venv/bin/activate

notebook:
	python3 tools/make_colab.py

chat: data/tokenizer.json checkpoints/best_model.pt checkpoints/config.json requirements
	$(ACTIVATE) && python -m guppylm $@

data/tokenizer.json checkpoints/best_model.pt checkpoints/config.json:
	$(ACTIVATE) && make download

prepare: requirements
	$(ACTIVATE) && python -m guppylm $@

train: prepare
	$(ACTIVATE) && python -m guppylm $@

requirements: requirements.txt
	pip install -r $^

activate:
	python3 -m venv .venv
	echo "Virtual environment ready. Now you can active it with: . .venv/bin/activate"

download:
	$(ACTIVATE) && python -m guppylm $@

clean:
	- rm -rf venv data checkpoints

