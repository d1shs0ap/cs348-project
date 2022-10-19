
update stocks_table as st
set st.num_stocks = st.num_stocks + 15
where st.uid = 111 and st.lid = 999 and st.ticker_sym = 'goog'
;

update stocks_table as st
set st.price = st.price - 15 * (
            select price 
            from stock_data as sd 
            where sd.ticker_sym = 'goog' 
                and sd.stock_time = '2022-10-19-1:48')
where st.uid = 111 and st.lid = 999 and st.ticker_sym = 'cash'
;