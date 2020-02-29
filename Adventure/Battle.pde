/*******************************************
 have battle with monster
********************************************/

boolean dodge = false, esc = true;
boolean inBattle = false;
boolean show_damage = false;
boolean arrive = false, returned = false;
int battle_UI_margin = 10;
float c_width = (width - battle_UI_margin * 5)/4, c_height = height/3 - 2 * battle_UI_margin;
float cx, cy = height*2/3 + battle_UI_margin;
  float attacker_x, attacker_y;
  float defender_x, defender_y;
  float distance_x, distance_y;
  int atk, def;

/*******************************************
 calculation damage
********************************************/

void dmg(float x, int rec, int rec_type){
  show_damage = true;
  start_frame = frameCount;
  
  if(rec_type == 1){
    hit[0] = rec;
    p[rec].dec_hp(x);
    p[rec].calc_stats();
    
    dmg_x = rec * pc_width/2.0f + pcx + pc_width/2;
    dmg_y = rec*pc_height*1.5f + pcy + pc_height;
    display_dmg = (int)x;
  }else{
    hit[0] = rec;
    m[rec].dec_hp(x);
    m[rec].calc_stats();
    
    enemy_start_x = battle_UI_margin + (float)enemy_width;
    enemy_start_y = battle_UI_margin + enemy_height/2.0f;
    enemy_x = enemy_start_x + enemy_width * m[0].get_mod();
    enemy_y = enemy_start_y;
    for(int i = 0; i < enemy_count; i++){
      if(i != 0){
        if(i % 2 == 0){
          enemy_x += enemy_width * m[i-1].get_mod();
        }else{
          enemy_x -= enemy_width * m[i-1].get_mod();
        }
      }
      
      if(rec == i){
          dmg_x = enemy_x + enemy_width * m[rec].get_mod();
          dmg_y = enemy_y + enemy_height * m[rec].get_mod();
      }
    
      enemy_y += enemy_height * m[i].get_mod() + enemy_height/2.0;
    }
    display_dmg = (int)x;
    //println((int)x);
    //println("dmg: " + m[rec].get_hp_dec());
  }
}

//def_type 1 = player, 0 = monster
void attack(int attacker, int defender, int def_type){
  start_frame = frameCount;
  float damage = 0.0f;
  
  if(def_type == 0){
    pid = attacker;
    mid = defender;
    
    atk = attacker;
    def = defender;
    attacker_x = p[attacker].battle_x;
    attacker_y = p[attacker].battle_y;
    defender_x = m[defender].battle_x;
    defender_y = m[defender].battle_y;
    distance_x = attacker_x - defender_x + m[defender].get_mod() * enemy_width;
    distance_y = attacker_y - defender_y;
    
    damage = p[attacker].get_patk() - m[defender].get_pdef();
    //println("a patk: " + p[attacker].get_patk() + " m pdef: " + m[defender].get_pdef());
    if(m[mid].buff_list[7] > 0){
        m[mid].buff_round[7] = 0;        
    }
    
    if(m[mid].buff_list[13]> 0){
        m[mid].buff_round[13] = 0;        
    } 
    
  //monster normal attack
  }else{
    mid = attacker;
    pid = defender;
    
    atk = attacker;
    def = defender;
    attacker_x = m[attacker].battle_x;
    attacker_y = m[attacker].battle_y;
    defender_x = p[defender].battle_x;
    defender_y = p[defender].battle_y;
    distance_x = defender_x - attacker_x + m[attacker].get_mod() * enemy_width;
    distance_y = defender_y - attacker_y;
    println("atk: " + attacker + "def: " + defender);
    damage = m[attacker].get_patk() - p[defender].get_pdef();
    
    
}
  
  if(damage < 1){
    damage = 1;
  }
  
    dodge = false;
  
   if_dodge(attacker,defender, (def_type + 1)% 2);
  
  if(dodge){
    
    damage = 0;
    
    dmg(damage, defender, def_type);

}
  /*
  
   
  */
  
  else{
  
    dmg(damage, defender, def_type);
  
  }
  
  room= 91;
}


void skill(int releaser, int receiver, int def_type, int skill_id){
  float damage;
  if(def_type == 0){
    
    switch(p[releaser].skills.skill[skill_id].dmg_type){
        // cause true damage
        case 0:              
              if(p[releaser].get_cur_mp() - p[releaser].skills.skill[skill_id].mp_dec >= 0){
                
                pid = releaser;
                mid = receiver;
                hit[0] = receiver;
                
                p[releaser].skills.skill[skill_id].skilldamage();
                
                damage = p[releaser].skills.skill[skill_id].damage;
                
                if(damage < 1){
                        damage = 1;
                      }
                      
                if(m[mid].buff_list[7] > 0){
                        m[mid].buff_round[7] = 0;        
                    }
                    
                    if(m[mid].buff_list[13]> 0){
                        m[mid].buff_round[13] = 0;        
                    }      
                
                p[releaser].dec_mp( p[releaser].skills.skill[skill_id].mp_dec);  
                dmg(damage,receiver,def_type);
                p[releaser].calc_stats();            
          
            }else{
              room = 94;
                select_target = false;
            }

         break;
              // cause physical damage
        case 1:
              if(p[releaser].get_cur_mp() - p[releaser].skills.skill[skill_id].mp_dec >= 0){
                
                pid = releaser;
                mid = receiver;
                hit[0] = receiver;

                p[releaser].skills.skill[skill_id].skilldamage();
                
                damage = p[releaser].skills.skill[skill_id].damage-m[receiver].get_pdef();
                
                if(damage < 1){
                        damage = 1;
                      }
                      
                if(m[mid].buff_list[7] > 0){
                        m[mid].buff_round[7] = 0;        
                    }
                    
                    if(m[mid].buff_list[13]> 0){
                        m[mid].buff_round[13] = 0;        
                    } 
                
                p[releaser].dec_mp( p[releaser].skills.skill[skill_id].mp_dec);  
                dmg(damage,receiver,def_type);
                p[releaser].calc_stats();    
                
          //not enough mp      
          }else{
                room = 94;
                select_target = false;
              }
          break;
                // cause magical damage
        case 2:
              if(p[releaser].get_cur_mp() - p[releaser].skills.skill[skill_id].mp_dec >= 0){
                
                pid = releaser;
                mid = receiver;
                hit[0] = receiver;
                
                p[releaser].skills.skill[skill_id].skilldamage();                
                
                damage = p[releaser].skills.skill[skill_id].damage - m[receiver].get_mdef();
                
                if(damage < 1){
                        damage = 1;
                      }
                      
                if(m[mid].buff_list[7] > 0){
                        m[mid].buff_round[7] = 0;        
                    }
                    
                    if(m[mid].buff_list[13]> 0){
                        m[mid].buff_round[13] = 0;        
                    } 
                
                p[releaser].dec_mp( p[releaser].skills.skill[skill_id].mp_dec);  
                dmg(damage,receiver,def_type);
                p[releaser].calc_stats();
            
          //not enough mp  
          }else{
                room = 94;
                select_target = false;
              }
              
          break;
                  // recovery mp or hp
       case 3:
             if(p[releaser].get_cur_mp() - p[releaser].skills.skill[skill_id].mp_dec >= 0){
                 pid = receiver;
                p[releaser].skills.skill[skill_id].skilldamage();
                
                       if(p[releaser].skills.skill[skill_id].healing){
                         p[receiver].rec_hp( p[releaser].skills.skill[skill_id].heal);
                         p[releaser].dec_mp( p[releaser].skills.skill[skill_id].mp_dec);
                         p[releaser].calc_stats();
                         p[receiver].calc_stats();
                     }
                     else{
                         p[receiver].rec_mp(p[releaser].skills.skill[skill_id].heal);
                         p[releaser].dec_mp(p[releaser].skills.skill[skill_id].mp_dec);
                         p[releaser].calc_stats();
                         p[receiver].calc_stats();
                     }          
             }
             else{
               room = 94;
                select_target = false;
             }
           break;
                     // buff set
      case 4:
            if(p[releaser].get_cur_mp() - p[releaser].skills.skill[skill_id].mp_dec >= 0){
                
                pid = receiver;
                p[releaser].skills.skill[skill_id].skilldamage();
                
                       p[releaser].skills.skill[skill_id].skillUsed();
                       p[releaser].calc_stats();

                       
                       p[releaser].dec_mp(p[releaser].skills.skill[skill_id].mp_dec);
                       p[releaser].calc_stats();          
             }
             else{
               room = 94;
                select_target = false;
             }
                         
           break;
    }
  }
  
  else{
    //m[attacker].skills.skill[skill_id].skilldamage();
     
     //println("monster use skill");
     
     mid = releaser;
     
     pid = receiver;

    switch(m[releaser].skills.skill[skill_id].dmg_type){
              // cause physical damage
        case 1:
              if(m[releaser].get_cur_mp() - m[releaser].skills.skill[skill_id].mp_dec >= 0){
                
                hit[0] = receiver;

                m[releaser].skills.skill[skill_id].skilldamage();
                
                damage = m[releaser].skills.skill[skill_id].damage - p[receiver].get_pdef();
                
                if(damage < 1){
                        damage = 1;
                      }
               
                m[releaser].dec_mp( p[releaser].skills.skill[skill_id].mp_dec);  
                
                dmg(damage,receiver,def_type);
                
                m[releaser].calc_stats();
                m[receiver].calc_stats();
               
          }
              else{
                select_target = false;
              }
          break;
                // cause magical damage
        case 2:
              if(m[releaser].get_cur_mp() - m[releaser].skills.skill[skill_id].mp_dec >= 0){
                
                hit[0] = receiver;
                
                m[releaser].skills.skill[skill_id].skilldamage();                
                
                damage = m[releaser].skills.skill[skill_id].damage - p[receiver].get_mdef();
                
                if(damage < 1){
                        damage = 1;
                      }

                m[releaser].dec_mp( m[releaser].skills.skill[skill_id].mp_dec);  
                dmg(damage,receiver,def_type);
                m[releaser].calc_stats();
                m[receiver].calc_stats();
            
          }
              else{
                select_target = false;
              }
              
          break;
                  // recovery mp or hp
       case 3:
             if(m[releaser].get_cur_mp() - m[releaser].skills.skill[skill_id].mp_dec >= 0){
               
                m[releaser].skills.skill[skill_id].skilldamage();
                
                       if(m[releaser].skills.skill[skill_id].healing){
                         m[releaser].rec_hp( m[releaser].skills.skill[skill_id].heal);
                         m[releaser].dec_mp( m[releaser].skills.skill[skill_id].mp_dec);
                         m[releaser].calc_stats();
                         m[receiver].calc_stats();
                     }
                     else{
                         m[releaser].rec_mp(p[releaser].skills.skill[skill_id].heal);
                         m[releaser].dec_mp(p[releaser].skills.skill[skill_id].mp_dec);
                         m[releaser].calc_stats();
                         m[receiver].calc_stats();
                     }          
             }
             else{
                select_target = false;
             }
           break;
    }
  }
}

void ani_draw(int cover, int type){
  textSize(40);
  pc_width = (width/3.0f - 4.0f * battle_UI_margin)/ (float)(max_pt + 1);
  pc_height = (height*2/3 - 3.0f * battle_UI_margin)/ (float)(max_pt + 2);
  pcx = width*2/3.0f + battle_UI_margin + (float)(max_pt/2.0) * pc_width;
  pcy = battle_UI_margin + pc_height/2.0f;
  
  enemy_width = (width/3.0f - 4.0f * battle_UI_margin)/ (float)(max_pt+1);
  enemy_height = (height*2/3.0f - 3.0f * battle_UI_margin)/ (float)(max_pt+2);
  enemy_start_x = battle_UI_margin + (float)enemy_width;
  enemy_start_y = battle_UI_margin + enemy_height/2.0f;
  enemy_x = enemy_start_x + enemy_width * m[0].get_mod();
  enemy_y = enemy_start_y;
  
  //Draw enemies
  noStroke();
  for(int i = 0; i < enemy_count; i++){
    if(i == 0){
      if(m[0].is_alive()){
        if(type == 0){
          if(cover != i){
            image(m[i].img, enemy_x, enemy_y, enemy_width * m[i].get_mod(), enemy_height * m[i].get_mod());
            m[i].battle_x = enemy_x;
            m[i].battle_y = enemy_y;
          }
        }else{
          image(m[i].img, enemy_x, enemy_y, enemy_width * m[i].get_mod(), enemy_height * m[i].get_mod());
          m[i].battle_x = enemy_x;
          m[i].battle_y = enemy_y;
        }
      }else{
        fill(0,100,100);
        rect( enemy_x, enemy_y, enemy_width * m[i].get_mod(), enemy_height * m[i].get_mod());
      }
    }else{
      
      if(i % 2 == 0){
        enemy_x += enemy_width * m[i-1].get_mod();
      }else{
        enemy_x -= enemy_width * m[i-1].get_mod();
      }
      
      if(m[i].is_alive()){
        if(type == 0){
          if(cover != i){
            image(m[i].img, enemy_x, enemy_y, enemy_width * m[i].get_mod(), enemy_height * m[i].get_mod());
            m[i].battle_x = enemy_x;
            m[i].battle_y = enemy_y;
          }
        }else{
          image(m[i].img, enemy_x, enemy_y, enemy_width * m[i].get_mod(), enemy_height * m[i].get_mod());
          m[i].battle_x = enemy_x;
          m[i].battle_y = enemy_y;
        }
      }else{
        fill(0,100,100);
        rect( enemy_x, enemy_y, enemy_width * m[i].get_mod(), enemy_height * m[i].get_mod());
        m[i].battle_x = enemy_x;
        m[i].battle_y = enemy_y;
      }
    }
    
    enemy_y += enemy_height * m[i].get_mod() + enemy_height/2.0;
    //println("enemy y: " + enemy_y + " i: " + i);
    //println("mob lv: " + m[i].get_level() + " patk: " + m[i].get_patk());
  }
  
  //Draw player status boxes
  p_box();
  
  //Draw player images and player status
  for(int i = 0; i < c_pt; i++){
    if(p[i].is_alive()){
      p[i].battle_x = i*pc_width/2.0f + pcx;
      p[i].battle_y = i*pc_height*1.5f + pcy;
      
      if(type == 1){
        if(cover != i){
          image(p[i].battle_img, p[i].battle_x, p[i].battle_y, pc_width, pc_height);
        }
      }else{
        image(p[i].battle_img, p[i].battle_x, p[i].battle_y, pc_width, pc_height);
      }
      
      //over head hp bar
      hp_percent = (float)p[i].get_cur_hp() / (float)p[i].get_max_hp();
      strokeWeight(1);
      stroke(0,100,0);
      fill(0,0,100);
      rect(i*pc_width/2.0f + pcx, i*pc_height*1.5f + pcy - battle_UI_margin * 2, pc_width, battle_UI_margin, 50);
      fill(0,100,100);
      rect(i*pc_width/2.0f + pcx, i*pc_height*1.5f + pcy - battle_UI_margin * 2, pc_width * hp_percent, battle_UI_margin, 50);
    }
      
        //player stats
        p_stats(i);
      
    }
}

void attackanimation(int attacker, int def_type){
  
  display_buff_icons();
  
  if(def_type == 0){
    noStroke();
    //fill(0,0,100);
    //rect(p[attacker].battle_x, p[attacker].battle_y, pc_width, pc_height);
    
    if(!arrive){
      if(attacker_x > defender_x + m[def].get_mod() * enemy_width){
        //println("move");
        //println("atk_x: " + attacker_x + " atk_y: " + attacker_y);
        image(p[attacker].battle_img, attacker_x, attacker_y, pc_width, pc_height);
      
        attacker_x -= distance_x/rate;
        attacker_y -= distance_y/rate;
      }else{
        arrive = true;
      }
    }else{
      if(attacker_x < p[attacker].battle_x){
        image(p[attacker].battle_img, attacker_x, attacker_y, pc_width, pc_height);
      
        attacker_x += distance_x/rate;
        attacker_y += distance_y/rate;
      }else{
        returned = true;
      }
    }
    
    if(returned){
      room = 90;
      battle_mode = 10;
      arrive = false;
      returned = false;
    }
    
    //println("monster x: " + m[def].battle_x + " px : " + attacker_x);
    //println("monster y: " + m[def].battle_y + " py : " + attacker_y);
  }else{
    //println("monster attack");
    noStroke();
    //fill(0,0,100);
    //rect(p[attacker].battle_x, p[attacker].battle_y, pc_width, pc_height);
    
    if(!arrive){
      //println("monster go");
      if(attacker_x + m[atk].get_mod() * enemy_width < defender_x ){
        
        image(m[attacker].img, attacker_x, attacker_y, m[atk].get_mod() * enemy_width, m[atk].get_mod() * enemy_height);
      
        attacker_x += distance_x/rate;
        attacker_y += distance_y/rate;
      }else{
        arrive = true;
      }
      
    }else{
      //println("monster back");
      if(attacker_x > m[atk].battle_x){
        image(m[attacker].img, attacker_x, attacker_y, m[atk].get_mod() * enemy_width, m[atk].get_mod() * enemy_height);
      
        attacker_x -= distance_x/rate;
        attacker_y -= distance_y/rate;
      }else{
        returned = true;
      }
    }
    
    if(returned){
      room = 90;
      battle_mode = 10;
      arrive = false;
      returned = false;
    }
    
  }

}

void escape(){
  
    int escape = r.nextInt(100);
    
    if(escape >= 60){
      
      inBattle = false;
      esc = true;
  
      room = map.get_map_room();
    }
    
    else{

      
      cur = (cur + 1) % (c_pt + enemy_count);
      //println("escape fail, cur: " + cur);
      esc = false;
      if(battle_list[cur].get_type() == 0){
        battle_mode = -1;
      }else{
        battle_mode = 0;
      }
    
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
  for(int i = 0; i < enemy_count; i++){
    m[i].set_id(i);
    
    if(elite_count - i > 0){
      m[i].setMType(2);
      m[i].set_level(r.nextInt(100) % 5 + 1 + (floor-1) * 5);
      m[i].init_stats();
    }else{
      m[i].setMType(1);
      m[i].set_level(r.nextInt(100) % 5 + 1 + (floor-1) * 5);
      m[i].init_stats();
    }
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

void battle_end(){
  int player_dead_count = 0, monster_dead_count = 0;
  
  for(int i = 0; i < c_pt; i++){
    if(!p[i].is_alive()){
      player_dead_count++;
    }
  }
  
  for(int i = 0; i < enemy_count; i++){
    if(!m[i].is_alive()){
      monster_dead_count++;
    }
  }
  
  if(player_dead_count == c_pt){
    
    //println("GAME OVER!");
    
    inBattle = false;
    
    room = 2;
  }
  else if(monster_dead_count == enemy_count)
  {
    //println("Victory!");
    
    start_frame = frameCount;
    
    inBattle = false;
    
    room = 2;
    
    int total_exp = 0,total_gold = 0;
    
    //gain exp and gold while victory
    for(int i = 0; i < c_pt; i++)
    {
      for(int j = 0;j<enemy_count;j++)
      {
         total_exp += m[i].getExp();
         total_gold += m[i].get_gold();      
       }     
       p[i].gainExp(total_exp);
    }
     p[0].gold_inc(total_gold);

    //caculate buff
    for(int i = 0; i < c_pt; i++)
    {
      for(int j = 0;j<buff_count;j++)
      {
        p[i].buff_list[j] = 0;
        p[i].buff_round[j] = 0;
      }
    }
    
    for(int i = 0; i < enemy_count; i++)
    {
      for(int j = 0;j < buff_count;j++)
      {
        m[i].buff_list[j] = 0;
        m[i].buff_round[j] = 0;
      }
    }
    
    loot();
  }
}

void display_damage(int target, int def_type){
  //println("display damage");
  fill(30,70,100);
  noStroke();
  rect(command_x - command_radius, command_y - command_radius, command_radius * 2, command_radius * 2, 20);
  
  stroke(0,100,100);
  strokeWeight(2);
  textSize(30);
  fill(0,100,100);
  if(!esc){
    text("Escape Failed!" , command_x , command_y - command_radius/2);
  }
  switch(def_type){
    case 0:
      text(battle_list[cur].name + " dealt " + display_dmg + " to " + m[target].name, command_x, command_y);
      break;
    case 1:
      text(battle_list[cur].name + " dealt " + display_dmg + " to " + p[target].name, command_x, command_y);
      break;
  }
}

void hit_set(){
    for(int i = 0; i < max_pt; i++){
      hit[i] = -1;
    }
}
