insert into stocks_table
values (111, 'amd', 30, (select price 
                            from stock_data as sd
                            where sd.ticker_sym = 'amd'
                            and sd.stock_time = '2022-10-19-1:48')
                        , 999)
;

update stocks_table as st
set st.price = st.price - 30 * (
            select price
            from stock_data as sd
            where sd.ticker_sym = 'amd'
                and sd.stock_time = '2022-10-19-1:48')
where st.uid = 111 and st.lid = 999 and st.ticker_sym = 'cash'
;
