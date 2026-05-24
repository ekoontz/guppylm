.PHONY: chat train notebook clean

ACTIVATE=python3 -m venv .venv && . .venv/bin/activate

chat: checkpoints/best_model.pt checkpoints/config.json
	$(ACTIVATE) && python -m guppylm $@

train: checkpoints/best_model.pt checkpoints/config.json

checkpoints/best_model.pt checkpoints/config.json: data/tokenizer.json
	$(ACTIVATE) && python -m guppylm train

data/tokenizer.json: data/eval.jsonl data/train.jsonl
	$(ACTIVATE) && python -m guppylm tokenizer

data/eval.jsonl data/train.jsonl: .venv
	$(ACTIVATE) && python -m guppylm generate_training_data

.venv: requirements.txt
	$(ACTIVATE) && pip install -r $^

notebook: gupplylm/train_guppylm.ipynb gupplylm/use_guppylm.ipynb

gupplylm/train_guppylm.ipynb gupplylm/use_guppylm.ipynb:
	python3 tools/make_colab.py

clean:
	- rm -rf .venv data checkpoints gupplylm/train_guppylm.ipynb gupplylm/use_guppylm.ipynb


