Material 
Indicator	
Commitment	
Investment 
Law	
Amortize	
Amortization 
Start Date



---exem:
Select *

from 
PO_headers_all
where
segment1 = 'PUSA9020030484'

select *
from
PO_LINES_ALL

select 
HEADER.segment1 as "Order",
LINE_LOCATION.ASSESSABLE_VALUE

from
PO_LINE_LOCATIONS_ALL LINE_LOCATION
    LEFT JOIN PO_LINES_ALL LINE
       ON LINE_LOCATION.PO_LINE_ID = LINE.PO_LINE_ID
    left join PO_HEADERS_ALL HEADER
        on LINE.PO_HEADER_ID = HEADER.PO_HEADER_ID
    left join PO_DISTRIBUTIONS_ALL DISTRIBUTION
        on  HEADER.PO_HEADER_ID = DISTRIBUTION.PO_HEADER_ID

where
LINE.LINE_STATUS ='OPEN'
and LINE.PO_LINE_ID = '218'

