.PHONY: notebook chat tokenizer generate_training_data train activate download clean

ACTIVATE=python3 -m venv .venv && . .venv/bin/activate

notebook:
	python3 tools/make_colab.py

chat: data/tokenizer.json checkpoints/best_model.pt checkpoints/config.json .requirements
	$(ACTIVATE) && python -m guppylm $@

data/tokenizer.json checkpoints/best_model.pt checkpoints/config.json: train

tokenizer: .requirements generate_training_data
	$(ACTIVATE) && python -m guppylm $@

train: tokenizer
	$(ACTIVATE) && python -m guppylm $@

generate_training_data: .requirements
	$(ACTIVATE) && python -m guppylm $@

.requirements: requirements.txt
	pip install -r $^
	touch $@

activate:
	python3 -m venv .venv
	echo "Virtual environment ready. Now you can active it with: source .venv/bin/activate"

clean:
	- rm -rf venv data checkpoints .requirements

