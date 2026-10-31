"""Load the cleaned Tableau-ready CSV into SQLite and execute portfolio SQL queries.
Usage: python run_sql_analysis.py /path/to/Retail_Tableau_Dashboard_Data_With_CustomerID.csv
"""
from pathlib import Path
import sqlite3
import sys
import pandas as pd

CSV = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('Retail_Tableau_Dashboard_Data_With_CustomerID.csv')
if not CSV.is_file():
    raise SystemExit(f'CSV not found: {CSV}\nSupply its path: python run_sql_analysis.py path/to/file.csv')
ROOT = Path(__file__).resolve().parent
SQL_FILE = ROOT / 'sql' / 'retail_analysis.sql'
OUTPUT = ROOT / 'results'
OUTPUT.mkdir(exist_ok=True)

# Preserve invoice identifiers as text (some invoice codes contain letters).
df = pd.read_csv(CSV, dtype={'InvoiceNo': 'string', 'CustomerID': 'string'}, low_memory=False)
required = {'InvoiceNo', 'CustomerID', 'Description', 'Quantity', 'TotalRevenue', 'Country', 'Segment', 'MonthYear'}
missing = required - set(df.columns)
if missing:
    raise SystemExit(f'Missing required columns: {sorted(missing)}')

with sqlite3.connect(':memory:') as conn:
    df.to_sql('retail', conn, index=False, if_exists='replace', chunksize=10000)
    conn.execute('CREATE INDEX idx_retail_invoice ON retail (InvoiceNo)')
    conn.execute('CREATE INDEX idx_retail_month ON retail (MonthYear)')
    conn.execute('CREATE INDEX idx_retail_segment ON retail (Segment)')
    sql_text = SQL_FILE.read_text(encoding='utf-8')
    import re
    statements = [re.sub(r'(?m)^\s*--.*$', '', s).strip() for s in sql_text.split(';')]
    for idx, statement in enumerate((s for s in statements if s), start=1):
        result = pd.read_sql_query(statement, conn)
        if idx != 6:  # Avoid publishing customer-level identifiers
            result.to_csv(OUTPUT / f'query_{idx:02d}.csv', index=False)
        print(f'\nQuery {idx} — {len(result)} rows')
        if idx == 6:
            print('Customer-level results withheld from public exports.')
        else:
            print(result.head(10).to_string(index=False))
print(f'\nSaved query outputs to: {OUTPUT}')
