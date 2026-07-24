# MIRA Reproduction Commands

Run from the repository root.

The scripts set `UV_CACHE_DIR=.uv-cache` so `uv run` works in sandboxed
environments where the default home cache is read-only.

## Setup

```bash
bash scripts/00_setup_env.sh
```

Edit `src/.env` after setup. At minimum, set:

```bash
OPENAI_API_KEY="..."
MIRA_MIMIC_RAW_BASE_DIR="/path/to/MIMIC_Dataset"
```

Expected default raw data layout:

```text
$MIRA_MIMIC_RAW_BASE_DIR/
└── physionet.org/files/
    ├── mimiciv/2.2/hosp/
    ├── mimic-iv-note/2.2/note/
    └── mimic-iv-ed/2.2/ed/
```

Check local MIMIC files:

```bash
bash scripts/01_check_mimic_paths.sh
```

If you already have approved PhysioNet access to all required MIMIC projects,
you can download the source directories with:

```bash
PHYSIONET_USERNAME=your_user bash scripts/download_mimic_required_sources.sh
```

This downloads the required source tables, not a patient-level sample.

## Dataset Build

Small smoke dataset, defaulting to `appendicitis` and 20 admissions:

```bash
bash scripts/02_make_dataset_small.sh
```

Override from args:

```bash
bash scripts/02_make_dataset_small.sh pancreatitis 5
```

Or override from env:

```bash
MIRA_DATASET_DIAGNOSES="appendicitis,pancreatitis" \
MIRA_MAX_HADM_IDS_PER_DIAGNOSIS=10 \
MIRA_OVERWRITE_DATASETS=yes \
bash scripts/02_make_dataset_small.sh
```

Full dataset build:

```bash
bash scripts/03_make_dataset_full.sh
```

For unattended overwrite during a full rebuild:

```bash
MIRA_OVERWRITE_DATASETS=yes bash scripts/03_make_dataset_full.sh
```

## Services

Start local HAPI FHIR:

```bash
bash scripts/04_start_fhir.sh
```

Start Qdrant in the foreground:

```bash
bash scripts/05_start_qdrant.sh
```

Keep that Qdrant terminal open while building the procedure vector DB and running simulations.

## Notebook Steps From The README

After dataset build:

1. Open and run `src/notebooks/extract_pancreatic_cancer_info.ipynb` only if running pancreatic-cancer cases.
2. Start Qdrant with `bash scripts/05_start_qdrant.sh`.
3. Open and run `src/notebooks/build_procedure_db.ipynb`.
4. Open run notebooks from `src/runs/`:
   - baseline: `src/runs/run_simulation.ipynb`
   - bias: `src/runs/run_simulation_bias.ipynb`
   - optional admission: `src/runs/run_simulation_optional_admission.ipynb`
5. Open evaluation notebooks from `src/evaluations/`.

## MIMIC Small/Sample Data

The repo can build a small derived dataset with `MIRA_MAX_HADM_IDS_PER_DIAGNOSIS`, but that still requires local access to the full source tables it reads.

PhysioNet has an open MIMIC-IV Clinical Database Demo:

```bash
bash scripts/download_mimic_demo_hosp_only.sh
```

That demo is not sufficient for this MIRA pipeline because it excludes free-text clinical notes and does not provide the required MIMIC-IV-Note/MIMIC-IV-ED files used by `src/dataset/make_dataset.py`.
