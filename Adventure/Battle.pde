/*******************************************
 have battle with monster
********************************************/

boolean dodge = false;
boolean inBattle = false;
int battle_UI_margin = 10;
int max_pt = 4, c_pt = 1;
float c_width = (width - battle_UI_margin * 5)/4, c_height = height/3 - 2 * battle_UI_margin;
float cx, cy = height*2/3 + battle_UI_margin;

/*******************************************
 calculation damage
********************************************/

void dmg(float x, int rec, int rec_type){
  if(rec_type == 1){
    p[rec].dec_hp(x);
    p[rec].calc_stats();
  }else{
    m[rec].dec_hp(x);
    m[rec].calc_stats();
  }
}

//def_type 1 = player, 0 = monster
void attack(int attacker, int defender, int def_type){
  
  float damage = 0.0f;
  
  if(def_type == 0){
    damage = p[attacker].get_patk() - m[defender].get_pdef();
  }else{
    damage = m[attacker].get_patk() - p[defender].get_pdef();
  }
  
  if(damage <= 0){
    damage = 1;
  }
  
  println("a patk: " + m[attacker].get_patk() + " m pdef: " + p[defender].get_pdef());
  println("fn dmg: " + damage);
    dodge = false;
  
   //if_dodge(attacker,defender, (def_type + 1)% 2);
  
  
  if(dodge){
    
    damage = 0;
    
    dmg(damage, defender, def_type);

}
  /*
  
   
  */
  
  else{
  
    dmg(damage, defender, def_type);
  
  }
  
}



void skill_attack(int attacker, int defender, int def_type, int skill_id){
  float damage = p[attacker].get_patk() - p[defender].get_pdef();
  
  dmg(damage, defender, def_type);
}

void attackanimation(int attacker, int defender){
  //int attacker_X = p[attacker].;
  //int defender_X = p[defender].;


}

void escape(){
  
    int escape = r.nextInt(100);
    
    
    
    if(escape >= 60){
      
    inBattle = false;

    room = map.get_map_room();
    

    
    }
    
    else{

    println("escape fail");
    
    }
      
}

void if_dodge(int attacker,int defender, int attacker_type){
    
       
       float dodge_rate;
       
       if(attacker_type == 1){
         dodge_rate = (m[defender].get_spd()-p[attacker].get_spd())/m[defender].get_spd();
       }else{
         dodge_rate = (p[defender].get_spd()-m[attacker].get_spd())/p[defender].get_spd();
       }
       
        if(r.nextInt(10000) < dodge_rate * 10000)
        {
        
          dodge = true;
        
        }else{
          dodge = false;
        }
     
}

void enemy_setup(){
  int types;
  
  if(floor < 3){
    types = floor;
  }else{
    types = 1;
  }
  
  for(int i = 0; i < enemy_count; i++){
    m[i].setMType(r.nextInt(100) % types + 1);
    m[i].set_level(r.nextInt(100) % floor*5 + 1);
    m[i].init_stats();
  }
}

Units[] round_order(){
  Units[] u  = new Units[enemy_count + c_pt];
  Units temp;
  
  for(int i = 0; i < u.length; i++){
    if(i < c_pt){
      u[i] = p[i];
    }else{
      u[i] = m[i - c_pt];
    }
  }
  
  for(int i = 0; i < u.length - 1; i++){
    for(int j = 1; j < u.length; j++){
      if(u[i].get_spd() < u[j].get_spd()){
        temp = u[i];
        u[i] = u[j];
        u[j] = temp;
      }
    }
  }
  
  return u;
}