.PHONY: chat notebook clean

ACTIVATE=python3 -m venv .venv && . .venv/bin/activate

chat: checkpoints/best_model.pt checkpoints/config.json
	$(ACTIVATE) && python -m guppylm $@

checkpoints/best_model.pt checkpoints/config.json : data/tokenizer.json
	$(ACTIVATE) && python -m guppylm train

data/tokenizer.json: data/eval.jsonl data/train.jsonl
	$(ACTIVATE) && python -m guppylm tokenizer

data/eval.jsonl data/train.jsonl: .requirements
	$(ACTIVATE) && python -m guppylm generate_training_data

.requirements: requirements.txt
	pip install -r $^
	touch $@

notebook:
	python3 tools/make_colab.py

clean:
	- rm -rf venv data checkpoints .requirements

