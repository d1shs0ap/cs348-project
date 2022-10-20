select sd.ticker_sym, sd.price, sd.stock_time
from stock_data as sd
where sd.ticker_sym = 'goog'
;