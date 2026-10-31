# Data dictionary (key fields)

Fields expected by the SQL runner from the cleaned Tableau-ready export:

| Field | Description |
|---|---|
| `InvoiceNo` | Invoice/order identifier, kept as text |
| `CustomerID` | Customer identifier; may be missing |
| `Description` | Product or transaction line description |
| `Quantity` | Units in the transaction line |
| `TotalRevenue` | Transaction-line revenue in GBP |
| `Country` | Transaction country |
| `Segment` | RFM-derived customer segment; unidentified rows may have their own label |
| `MonthYear` | Year-month reporting period |

See the Python notebook for the full cleaning and feature-engineering logic. No row-level customer data is included here.
