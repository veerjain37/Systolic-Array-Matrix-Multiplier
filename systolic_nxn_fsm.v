module systolic_nxn_fsm #(parameter N=3)(
    input clk,
    input reset,
    input start,
    output reg pe_en,
    output reg [N-1:0] row_en,
    output reg [N-1:0] col_en,
    output reg done

    
);

// reg declaration 
reg [$clog2((3*N))-1: 0] count;
//after N-1 cycle last row gets first input linedup
// another N-1 cycle till last input get lined up
// another N cycle till last input drained out
// 1 cycle to move to don_state

reg [1:0] current_state; 
reg [1:0] next_state;
integer i ;  

//states declaration
localparam idle = 2'b00;
localparam stream =2'b01;
localparam drain= 2'b10;
localparam done_state = 2'b11;


//seq logic

always @(posedge clk ) begin
    if(reset) begin
        count<=0;
        current_state<=idle;
    end
    else begin
        current_state<=next_state;
        

        case (current_state)
        idle: begin
            count<=0;
        end
        stream,drain: begin
                     count<= count + 1'b1;
           end 
            default: begin
                count<=0;
            end
        endcase
    end
end

//next state logic
always @(*) begin

    // preventing latch formation
    next_state=current_state;
    done=1'b0;
    pe_en=1'b1;
    row_en=0;
    col_en=0;

    case (current_state)
       idle :begin
                pe_en=1'b0;
               
                if (start) begin
                    next_state=stream;

                end
        
       end 
       stream :begin
        // pe_an became 1 as soon as current_state<=stream in pos_edge of clk
        
        if(count<2*N-1) begin // N-1 for en all rows then N-1 to input last element of row
                                // total = 2N-2 then move to drain 
                                // ? does the last row get close in this , we will check after stimulation
                                // ans-> when we shift to drain , row stop updating so default row =3'b0;

            // I would like to try to redesgin this logic without for loop
            for (i =0 ; i<N ; i=i+1 ) begin

            row_en[i]= (count>=i) && (count< i+N); // each row[i] active for N cycles only then turned off
             // at count=N-1 all rows are en

            col_en[i]= (count>=i) && (count< i+N); // each col[i] active for N cycles only
            end

        end

        else begin
            
            next_state=drain;

        end
        
        
       end
       drain :begin
         // at count 2N-1  at drain state , 
         // need N-1 more cycles for providing last element of last row to last PE 
                if(count>=3*N-2) begin
                    next_state=done_state;
                end
        // at N=3N-2 next_state is drain, count update to 3N-1 at seq logic as prev current state is still drain
        
       end

       done_state :begin
        done=1'b1;
        next_state=idle;
        
       end 
       default: ;
       
    endcase
end

endmodule