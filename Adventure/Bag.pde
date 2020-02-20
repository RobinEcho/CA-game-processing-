  /*******************************************
   set item count and reading object
  ********************************************/ 
   
   
   protected int item_count = 3;
   PImage item_pic[] = new PImage[item_count];
   PImage arrow[] = new PImage[2];



  /*******************************************
  key variable set here about bag
  ********************************************/ 



boolean inBag = false;
boolean  bagopt = false;



  /*******************************************
  Class Bag
  ********************************************/ 
class Bag{
  
  
  public int[][] inv;
  public int row, col;
  int UI_width, UI_height, UI_dis;
  int vertical_margin, horizontal_margin;
  float square_width, square_height, vs, hs;
  
  public Bag(int row, int col){
    
    inv = new int[row][col];
    this.row = row;
    this.col = col;
    UI_width = 500;
    UI_height = 800;
    UI_dis = 100;
    vertical_margin = (height - UI_height)/2;
    horizontal_margin = (width - 2*UI_width - UI_dis)/2;
    
    for(int i = 0; i < row; i++){
      for(int j = 0; j < col; j++)
      {
        //image(item_pic[j%3], (j+1)*hs + (j*square_width) + (width + UI_dis)/2, (i+1)*vs + (i * square_height) + vertical_margin, square_width, square_height);
        inv[i][j] = j%3;
      }    //for loop(j)
    }    //for loop (i)
    
  }                    //close Bag()
  
  
  /*******************************************
  To display bag
  ********************************************/ 

  public void display_bag(){
    PropertyPanel();
    BagSquare(1);
    if(move_item){
      image(item_pic[temp_item_code], mouseX - (bag.square_width/2), mouseY - (bag.square_height/2), bag.square_width, bag.square_height);
    }
  }                    //close display_bag()
  
/*-----------------------------------------------------------------------------------------------------*/

  public void PropertyPanel(){
    noStroke();
    fill(0);
    
    rect(horizontal_margin, vertical_margin, UI_width, UI_height);
    
  }                    //close PropertyPanel()


  /*******************************************
  BagSquare base on rows and column
  ********************************************/ 

  public void BagSquare(int mode){
    
    square_width = (float)UI_width / (float)(col+((col+1)/2.0));
    square_height = (float)UI_height / (float)(row+((row+1)/2.0));
    vs = square_height / 2;
    hs = square_width / 2;
    
    noStroke();
    fill(60, 100, 100);
    
    switch(mode){
      case 1:
        rect((width + UI_dis)/2, vertical_margin, UI_width, UI_height);
        
        fill(0, 0, 100);
        
        for(int i = 0; i < row; i++){
          for(int j = 0; j < col; j++)
          {
            image(item_pic[inv[i][j]], (j+1)*hs + (j*square_width) + (width + UI_dis)/2, (i+1)*vs + (i * square_height) + vertical_margin, square_width, square_height);
            
          }    //for loop(j)
        }    //for loop (i)
        break;
        
        case 2:
          rect(width/2 - UI_width, vertical_margin, UI_width * 2, (( (row / 2 + row % 2) + 1) *vs + (row / 2 + ((row) % 2)) * square_height));
        fill(0, 0, 100);
        
        for(int i = 0; i < row; i++){
          for(int j = 0; j < col; j++)
          {
            if(i > row / 2 - ((row + 1) % 2)){
              image(item_pic[inv[i][j]], (j+1)*hs + (j*square_width) + width/2, ((i+1-(row / 2 + row % 2))*vs + ((i-(row / 2 + ((row) % 2))) * square_height))+ vertical_margin, square_width, square_height);
            }else{
              image(item_pic[inv[i][j]], (j+1)*hs + (j*square_width) + width/2 - UI_width, ((i+1)*vs + (i * square_height))+ vertical_margin, square_width, square_height);
            }
            
          }    //for loop(j)
        }    //for loop (i)
        
        break;
      }
    }                    //close BagSquare()
   
}                    //cloase class Bag



public void loaditemimage(){

for(int i = 0; i < item_count; i++)
    {
      item_pic[i] = loadImage("src/item/map" + i + ".jpg");
    }


}