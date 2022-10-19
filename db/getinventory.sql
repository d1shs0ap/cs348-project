select ticker_sym, num_stocks * price as bal
from stocks_table as st
where st.uid = 111 and st.lid = 999
;