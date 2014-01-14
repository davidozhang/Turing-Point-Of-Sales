%
%   Program Description: This program is a virtual self-checkout for
%   SPARKS Computers & Gadgets Store with 10 items available for purchase.
%   User may purchase as many items as they want through scanning the
%   barcodes of the items they want. They may also cancel any of their
%   purchases through scanning 20202 while purchasing. They may then scan
%   the "End of Transaction" barcode to finish purchasing, and enter check-out
%   to pay for their items.
%   Date: February 4th, 2011
%   All Rights Reserved (R) David Zhang 2011.
%_________________________________________
%
%   The variable section is formatted as below for the ease of reading,
%   and the ease of changing the data. I have used arrays to make it convenient
%   for data adjustments. All the array variables are corresponding to one another.
% _________________________________________
var name : array 1 .. 10 of string := init (    %Array of the name of products.
    "MS 200 USB MOUSE",     %var:name(1)
    "MS COMFORT CURVE KYBD", %var: name(2)
    "LG 21.5 WDSCRN LCD MONITOR",   %var: name(3)
    "WD 640GB HARD DRIVE",  %var: name(4)
    "SAN DISK 32GB USB",    %var: name(5)
    "HP LASERJET LASER PRINTER",    %var: name(6)
    "LOGITECH USB MICROPHONE",      %var: name(7)
    "INTEL i5-580 PROCESSOR",       %var: name(8)
    "MSI NVIDIA GT240 1GB VIDEO CARD",          %var: name(9)
    "ASUS SABERTOOTH MTBD"  %var: name(10)
    )
var cost : array 1 .. 10 of real := init (  %Array of the price of products.
    12.99,  %var: cost(1)
    22.99,  %var: cost(2)
    179.99, %var: cost(3)
    65.99,  %var: cost(4)
    45.99,  %var: cost(5)
    75.99,  %var: cost(6)
    45.99,  %var: cost(7)
    275.99, %var: cost(8)
    95.99,      %var: cost(9)
    195.99  %var: cost(10)
    )
var barCode : array 1 .. 10 of int := init ( %Array of the barcodes of products.
    12345,  %var: barCode(1)
    23456,  %var: barCode(2)
    54321,  %var: barCode(3)
    98765,  %var: barCode(4)
    24680,  %var: barCode(5)
    35791,  %var: barCode(6)
    65789,  %var: barCode(7)
    43543,  %var: barCode(8)
    76543,  %var: barCode(9)
    55544   %var: barCode(10)
    )
var quantity : array 1 .. 10 of int := init ( %Array of the quantity purchased for
%each item. They are initialized to 0, and would be tallied up when purchases are made.
    0,  %var: quantity(1)
    0,  %var: quantity(2)
    0,  %var: quantity(3)
    0,  %var: quantity(4)
    0,  %var: quantity(5)
    0,  %var: quantity(6)
    0,  %var: quantity(7)
    0,  %var: quantity(8)
    0,  %var: quantity(9)
    0   %var: quantity(10)
    )
var promotion : array 1 .. 2 of int := init (    %Array of the promotional barcodes.
% These promotional codes could only be validated when asked by the program.
    34567,
    0
    )
var totalCost : real := 0   % This variable initializes the total cost to 0, so
% when user makes purchases, the total cost would be added up and displayed on
% the final receipt.
var cashAmount : real   % This variable stores the cash input given by the user
% This variable is only featured in the receipt.
var userInput : int     % This variable stores the barcode information scanned
% by user.
var userInput2 : int    % This variable is only used when user decides to cancel
% any of their orders.
var userInput3 : int    % This variable is reserved for storage of promotional barcodes
% scanned by user.
var userInput4 : string % This variable stores the user input of his/her name at the
% beginning of the program.
var userInput5 : string % This variable is only for storing "Y" or "N" to confirm cancellation
% of order.
var randomNumber : int % This variable is a random number generated for the GST receipt number.
var randomNumber2 : int % This variable is a random number generated for the PIN on the receipt.
var choice1 : boolean := false % This boolean variable helps judge invalid inputs and prompts
% the user to re-enter their inputs.
var choice2 : boolean := false % This boolean variable helps judge invalid inputs and promopts
% the user to re-enter their inputs.
var theDateTime, theDate, theTime : string % This variable exists to search through the
% computers date and time files so it could be displayed on the receipt.
theDateTime := Time.Date
theDate := theDateTime (1 .. 9)
theTime := theDateTime (11 .. *)
% User-friendly features are applied to provide customers with a friendly impression.
put "SPARK Computers & Gadgets Store - SPARK Your Imagination!"
delay (500)
put ""
put "Press enter your name to begin your SPARK Experience!" % This prompts the user for his/her name
% and makes the entire experience much more personal.
get userInput4
put ""
put "WELCOME to SPARK Self-Checkout, ", userInput4, "!"
delay (500)
put ""
put "Enter 10101 to enter check-out, and 20202 to cancel any purchases."
delay (500)
put ""
put "FRIENDLY NOTICE: Please set your run window dimensions to 100*100"
put "for optimal viewing of receipt."
delay (500)
put ""
% This section displays a menu for users to choose what they want to purchase.
% It includes the barcode, item name and its price. The menu is corresponding
% to the array variables; When the array data is adjusted or more items are added,
% the menu would always be updated and display the latest available items.
put "________________________________________________________"
put "Here are the available items for purchase:"
put ""
put "NOTE: The $5.40 EHF(Environmental Handling Fee) is ONLY"
put "applied to purchases of printers. (per unit)"
delay (250)
put ""
put "Barcode        Item                                 Price"
put ""
delay (250)
for i : 1 .. 10
    put barCode (i), "       ", name (i) : 40, cost (i) : 6
    delay (250)
end for
put ""
put "*********************PROMOTION *************************"
put "34567          20% off your entire purchase" % Promotional barcodes are available
% for this program. Once they are scanned, a corresponding promotion would be added to
% the final total and would be displayed on the receipt.
put ""
put "Only one promotion could be used at a time."
put ""

%   _________________________________________
%   A loop is set to continuously asks the user to scan their
%   purchases. The for loop is nested within the loop so that
%   everytime a user scans an item, it would search through the
%   entire array data to find the corresponding name and price.
%   After finding the item, the program will add up the quantity
%   and cost of the purchase.
%   _________________________________________

loop
    put "___________________________"
    put ""
    put "Please scan your purchase, ", userInput4, ": " .. %Prompts the user for input.
    get userInput % Gets the user input.
    exit when userInput = 10101 and totalCost > 0
    choice1 := false
    if userInput = 10101 and totalCost = 0 then % This prompts the user to purchase at least one item.
	% Checkout may not be accessed without any purchases.
	choice1:=true
	put "Empty Cart. Please scan one or more items."
    else
	for i : 1 .. 10
	    if userInput = barCode (i) then % Searches the array data for
		% the corresponding item.
		choice1 := true
		quantity (i) := quantity (i) + 1 % The quantity of purchase is
		% added up when user inputs a valid barcode.
		put quantity (i), "x ", name (i) % Displays purchase summary.
		totalCost := totalCost + cost (i) % The total cost is added up.
	    elsif userInput = 20202 then
		choice1 := true
	    end if
	end for
    end if
    for i : 1 .. 2
	if userInput = promotion (i) then       %This prompts the user to enter promotional barcodes
	    % only after scanning 'End of Transaction'.
	    choice1 := true
	    put "Please validate your promotional barcodes after scanning 'End of Transaction'."
	    exit
	else
	end if
    end for
    if choice1 = false then             %This prompts the user to provide a valid input.
	put "Please scan a valid barcode."
    end if
    if userInput = 20202 then     % Orders can be cancelled when user inputs '20202'.
	put "___________________________"
	put ""
	put "Scan the barcode for the item you would like to cancel"
	get userInput2
	for j : 1 .. 10
	    choice2 := false
	    if userInput2 not= barCode (j) then
		choice2 := true     %This would display a message and prompt the user to enter a valid
		% barcode.
	    end if
	    if userInput2 = barCode (j) and quantity (j) = 0 then     %A message is displayed to inform
		% the user that he/she has not purchased an individual item, thus cannot cancel it.
		put "Sorry, You have not purchased a ", name (j), " yet."
		exit
	    end if
	    %If the user has already purchased an individual, they would be prompted to confirm their
	    % cancellation. If the response is positive, then the quantity would be reduced by 1, and
	    % the total cost would be reduced by the cost of the individual item. A message would be
	    % displayed to inform the user of the cancellation.
	    if userInput2 = barCode (j) and quantity (j) >= 1 then
		choice2 := false
		put "Are you sure you want to cancel 1 ", name (j), "? (Y for Yes, N for No)"
		get userInput5
		if userInput5 = "Y" or userInput5 = "y" then
		    choice2 := true
		    quantity (j) := quantity (j) - 1
		    if quantity (j) < 0 then
			put "Sorry, You may not cancel any more of this item."
		    end if
		    totalCost := totalCost - cost (j)
		    put quantity (j), "x ", name (j)
		end if
	    end if
	end for
	if choice2 = true then     % This message would prompt the user to enter a valid input.
	    put "Please scan a valid barcode."
	end if
    end if
end loop

put "" % Before the user enters check-out, he/she must pass through a promotional barcode scanning
% period, in which they could input 1 and only 1 promotional barcode. If they do not use one, then
% they could continue directly to checkout by scanning '10101'.
%
put "Scan any promotion barcode here, or else scan 'End of Transaction' to continue"
put "directly to checkout."
get userInput3
for i : 1 .. 2
    if userInput3 = promotion (i) then % This part analyzes the promotional barcode, and would display
	% a message indicating the promotion. Then it would display a message showing that it is entering
	% checkout.
	put ""
	put "20% OFF DISCOUNT"
	delay (1000)
	put ""
	put "ENTERING CHECKOUT"
	delay (500)
	totalCost := totalCost * 0.8
	exit
    elsif userInput3 = 10101 then
	exit
    end if
end for
put "Please enter a valid input."
cls
put "PROCESSING, PLEASE WAIT..."
delay (2000)
cls
%The receipt is displayed as below. It features a professional look, and lists many
% information such as the store name, slogan, location, time & date, phone
% number, and a randomly generated GST receipt number.
loop
    put "SPARK COMPUTERS & GADGETS STORE"
    put "SPARK Your Imagination!"
    put "5550 Yonge Street, Toronto    ", Time.Date %This is where the time and date are displayed.
    randint (randomNumber, 1, 1000000000)
    put "416-512-0489 GST Reg # R", randomNumber
    put ""
    put "               SALES"
    put ""
    put ""
    for i : 1 .. 10
	if quantity (i) >= 1 then % Any purchase of individual items would be displayed here, as long as their
	    %quantity is more or equivelant to 1. It would display the barcode, item name, quantity in brackets, and its
	    % cost.
	    put barCode (i), " ", name (i) (1 .. *) : 30, "(", quantity (i), ")", "  $ ", cost (i) * quantity (i) : 6
	end if
    end for
    for i : 1 .. 2 % For any promotional items used, a line displaying the promotion would be shown, and the amount
	% of money reducted would also be shown.
	if userInput3 = promotion (i) then
	    put promotion (i), " 20% DISCOUNT", "                       $ -", totalCost / 0.8 * 0.2 : 5 : 2
	end if
    end for
    put ""
    put ""  % In the end, the subtotal, HST and total would be displayed. In addtion, an EHF fee would also be displayed
    % if there is any purchase of printers. $5.40 is the fee for ONE printer.
    put "                       _________"
    put "                        SUBTOTAL   ----  $", totalCost : 7 : 2 % The subtotal.
    if quantity (6) >= 1 then
	put "                        EHF(PRINTER) --  $  ", 5.40 * quantity (6):5:2 % The amount of EHF fee.
    end if
    put "                        HST (13%)  ----  $", totalCost * 0.13 : 7 : 2  %HST tax.
    put "                       _________"
    put "                        TOTAL      ----  $", totalCost * 1.13 : 7 : 2
    put "                        CASH       ----  $ " ..
    get cashAmount  %The user would then enter the amount of cash he/she would give, and the program would keep prompting
    % the user to enter a value that is equal to or greater than the total cost. It would not proceed until the response
    % is valid. An error message would be displayed, and the user would have to try again.
    if cashAmount < totalCost * 1.13 then
	put "ERROR: INVALID CASH INPUT"
	delay (1000)
    else
	exit when cashAmount >= totalCost * 1.13
    end if
    cls %If the user input of cash amount is correct, the receipt would proceed, and display many different information on the receipt.
end loop
put "                       CHANGE      ----  $", cashAmount - totalCost * 1.13 : 7 : 2 % The amount of change would be displayed.
put ""
put ""
put "Thank you ", userInput4, " for shopping at SPARK COMPUTERS &"  % A warmm, personal greeting would be given to the user, and would
% welcome him back again.
put "GADGETS STORE! WE HOPE YOU ENJOYED THE EXPERIENCE!"
put ""
put "IMPORTANT: KEEP THIS RECEIPT IN A SAFE PLACE." % A message that informs the user to keep the receipt for further reference.
put ""
put "Sign up for a SPARK Gift Card and receive 10% in " % Promotional message for the store.
put "savings today!"
put ""
put "********************"
put "Would you like to earn $1000? Complete our survey &"   % Informs the user of a promotional survey that gives them a chance
% to win $1,000. A random number is then generated for his/her PIN number in order to participate in the event.
put "d tell us how we are doing. Visit www.sparkc&g.com/"
put "survey for complete details."
randint (randomNumber2, 1, 1000000)
put "Your PIN: ", randomNumber2
put "********************"
put ""  % The store's return policy is featured on every receipt, and informs the user of any information regarding returning & exchanging
% purchases. It is very important for the user to understand about the return policies in order to avoid any confusions.
put "OUR RETURN POLICY If for any reason you are not "
put "completely satisfied with your purchases, SPARK will"
put "gladly give you a full refund or exchange. Return  "
put "the product within 30 days in its original condition"
put "and packaging with the receipts. Returns and exchanges"
put "require your name, address, phone number & signature"
put "for audit and fraud prevention purposes. You may also"
put "talk to our Store GM, or call 416-512-0489 for further"
put "assistance. Terms and Conditions are subject to change"
put "without notice. (C) 2011 SPARK C&G STORE"
put ""
put "                   <<<     Customer Copy       >>>"
