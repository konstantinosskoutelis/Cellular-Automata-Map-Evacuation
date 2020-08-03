module  evacuation #(
  parameter width = 63,
  parameter height = 63,
  parameter bits = (width+1)*(height+1)-1,
  parameter number_of_exits = 4,
  parameter BITS= $clog2(width+1)

)(
  input logic clk,
  input logic rst,
  input logic [bits:0][2:0]mem,
  input logic [bits:0][12:0]weight,

  output logic [6:0] people_out
);

logic finished_loading;
logic [6:0] ppl_out;
logic [width:0][height:0][2:0] field;
logic [width:0][height:0][12:0] distance;
logic [8:0] column;
logic [8:0] row;
logic [12:0] cnt;
logic [5:0] x;
logic [5:0] y;
logic [5:0] x_min;
logic [5:0] y_min;
logic start;

assign people_out=ppl_out;

//==============================MEMORY============================================================================================
mem memory(
 .rst(rst),
 .mem(mem)
);
weights weig(
  .rst(rst),
  .weight(weight)
);

//==============================CALCULATING PLAYERS INSIDE MAP=====================================================================
int i=0,j=0,num_of_players=0,num_of_exits;
logic [(number_of_exits-1):0][1:0][BITS:0] exits;

always_comb begin
  num_of_players = 0;
  for(i= 0; i <=width; i++) begin
    for(j = 0; j <=height; j++) begin
      if(field[i][j] == 3'b100 ) begin // Player detected
        num_of_players++;	
      end 
    end
  end
  num_of_exits = 0;
end

//==========================MIN CALCULATOR=================================================
always_comb begin
  int u,d,l,r,d1,d2,d3,d4;
  logic [2:0] u_s,d_s,l_s,r_s,d1_s,d2_s,d3_s,d4_s;
  //Store neighbors' weights (if player => dist = 999)
  u=(field[x+1][y] == 3'b100) ? 999 : distance[x+1][y];
  d=(field[x-1][y] == 3'b100) ? 999 : distance[x-1][y];
  l=(field[x][y+1] == 3'b100) ? 999 : distance[x][y+1];
  r=(field[x][y-1] == 3'b100) ? 999 : distance[x][y-1];
  d1=(field[x+1][y+1] == 3'b100) ? 999 : distance[x+1][y+1];
  d2=(field[x+1][y-1] == 3'b100) ? 999 : distance[x+1][y-1];
  d3=(field[x-1][y-1] == 3'b100) ? 999 : distance[x-1][y-1];
  d4=(field[x-1][y+1] == 3'b100) ? 999 : distance[x-1][y+1];

 if (u<=d && u<=l && u<=r && u<=d1 && u<=d2 && u<=d3 && u<=d4) begin
   x_min=x+1;
   y_min=y;
 end else if (d<=u && d<=l && d<=r && d<=d1 && d<=d2 && d<=d3 && d<=d4) begin
   x_min=x-1;
   y_min=y;
 end else if(l<=u && l<=d && l<=r && l<=d1 && l<=d2 && l<=d3 && l<=d4) begin
   x_min=x;
   y_min=y+1;
 end else if(r<=u && r<=d && r<=l && r<=d1 && r<=d2 && r<=d3 && r<=d4) begin
   x_min=x;
   y_min=y-1;
 end else if(d1<=u && d1<=d && d1<=l && d1<=r && d1<=d2 && d1<=d3 && d1<=d4) begin
   x_min=x+1;
   y_min=y+1;
 end else if(d2<=u && d2<=d && d2<=l && d2<=r && d2<=d1 && d2<=d3 && d2<=d4) begin
   x_min=x+1;
   y_min=y-1;
 end else if(d3<=u && d3<=d && d3<=l && d3<=r && d3<=d1 && d3<=d2 && d3<=d4) begin
   x_min=x-1;
   y_min=y-1;
 end else begin
   x_min=x-1;
   y_min=y+1;
 end  
end

//===============================FSM========================================================
enum logic[2:0] {FILL=3'b000, MOVE=3'b001 , NEXT_PERSON=3'b010, CHECK_EXITS=3'b011, IDLE=3'b100} state;
// 001 <= toixos 000<=keno 010 <=eksodos 100 anthropos exits: [63,42] [34,63] [40,63] [0,16]
always_ff @(posedge clk,posedge rst) begin
   if(rst) begin
       finished_loading <= 0;
       field<='{default: 0};
       x<=width-1;
       y<=height-1;
       ppl_out<=0;
       start<=1;
       state<= FILL;
   end else begin
       case(state)

FILL: begin
   if(start) begin
    row<= width;
    column <= height;
    cnt <= 0;
    start<=0;
    state<=FILL;
  end else begin
   if(cnt<(width*height)+127) begin
     field[row][column]<=mem[cnt];
     distance[row][column]<=weight[cnt];
     cnt<=cnt+1;
     column<=column-1;
     if(column==0) begin
       row<=row-1;
       column<=height;
     end
     state<=FILL;
   end else begin
     finished_loading <= 1;
     state<=MOVE;
   end
 end
end

MOVE: begin
  if(field[x][y]==3'b100) begin
    if(field[x_min][y_min]!=3'b100) begin
      field[x_min][y_min]<=3'b100;
      field[x][y]<=3'b000;
    end
  end
state<= CHECK_EXITS;
end

CHECK_EXITS: begin
  if(field[63][42]==3'b100) begin
    field[63][42]<=3'b010;
    ppl_out<=ppl_out+1;
  end
  if(field[34][63]==3'b100) begin
    field[34][63]<=3'b010;
    ppl_out<=ppl_out+1;
  end
  if(field[40][0]==3'b100) begin
    field[40][0]<=3'b010;
    ppl_out<=ppl_out+1;
  end
  if(field[0][16]==3'b100) begin
    field[0][16]<=3'b010;
    ppl_out<=ppl_out+1;
  end
  state<=NEXT_PERSON;
end

NEXT_PERSON: begin
  if(y==1 && x==1)begin
    x<=width-1;
    y<=height-1;
    state<=MOVE;
  end else if(y==1 && x!=1) begin
    x<=x-1;
    y<=width-1;
    state<=MOVE;
  end else begin
    y<=y-1;
    state<=MOVE;
  end
end
IDLE: begin
end //State IDLE end
endcase
 end
end

endmodule
