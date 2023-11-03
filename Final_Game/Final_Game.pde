/*
import processing.sound.*;

SoundFile music;
SoundFile defeat;
SoundFile victory;
SoundFile coinC;
*/
final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = .6;
final static float JUMP_SPEED = 14; 
final static int NEUTRAL_FACING = 0; 
final static int RIGHT_FACING = 1; 
final static int LEFT_FACING = 2;
final static float WIDTH = SPRITE_SIZE*16;
final static float HEIGHT = SPRITE_SIZE*12;
final static float GROUND_LEVEL = HEIGHT-SPRITE_SIZE; 

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;
 



Player player;

PImage snow, crate, red_brick, brown_brick, playerImage, gold, spider, heart;
ArrayList<Sprite> platforms;
ArrayList<Coin> coins1;
ArrayList<Enemy> enemies; 
ArrayList<Heart> hearts;
int score;
int lives;
float view_x;
float view_y;
boolean gameOver;


//initialize them in setup().
void setup(){
  size(1000, 800);
  imageMode(CENTER);
  playerImage = loadImage("player_stand_right.png");
  player = new Player(playerImage, 0.8);
  player.center_x = 100;
  player.center_y = GROUND_LEVEL;
  enemies = new ArrayList<Enemy>();
  platforms = new ArrayList<Sprite>();
  coins1 = new ArrayList<Coin>();
  hearts = new ArrayList<Heart>();
  score = 0;
  lives = 3;
  view_x = 0;
  view_y = 0;
  gameOver = false;
  /*
  music = new SoundFile(this, "home.mp3");
  victory = new SoundFile(this,"victory.mp3");
  defeat = new SoundFile(this, "defeat.mp3");
  coinC = new SoundFile(this, "coin music.mp3");
  //music.play();
  */
  

 gold = loadImage("gold1.png");
 spider = loadImage("spider_walk_right1.png");
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  crate = loadImage("crate.png");
  snow = loadImage("snow.png");
  heart = loadImage("heart.png");
  createPlatforms("map.csv");
}

// modify and update them in draw().
void draw(){
  background(0);
 
  scroll();
 
  displayAll();
  if(!gameOver) {
    updateAll();
    checkDeath();
    collectCoins();
    collectHearts();  
  }
}

void displayAll() {
  player.display();
  for (Heart h: hearts) {
   h.display();
  } 
  for (Sprite s: platforms) {
   s.display();
  } 
  for (Enemy e: enemies) {
   e.display(); 
   
  }
  
  for(Coin coin: coins1)
    {
      coin.display();
      coin.update();
      coin.updateAnimation();
    }
  textSize(32);
  fill(255, 0, 0);
  text("Coins:" + score, view_x + 75, view_y + 50);
  text("Lives:" + lives, view_x + 75, view_y + 100);
  
  
  if (gameOver) {
    fill(0,0,255);
    
    text("GAME OVER!", view_x + width/2 - 150, view_y + height/2- 50);
    if (lives == 0) {
      //music.stop();
      //defeat.play();
      text("You Lose!", view_x + width/2 - 150, view_y + height/2);
    }
    else { 
      //music.stop();
      
     text("You Win!", view_x + width/2 - 150, view_y + height/2 );
     
    }
    text("Press SPACE to Play Again!", view_x + width/2 - 150, view_y + height/2 + 50);
    

}
else if (score == 15)  {
     
     gameOver = true; 
     //music.pause();
     //victory.play();
}
}

void updateAll() {
   resolvePlatformCollisions(player, platforms);
   player.updateAnimation();
   for (Enemy e: enemies) {
     e.update();
   
  } 
  
}

void collectCoins() {

  
 ArrayList<Coin> collision_list = checkCollisionList1(player,coins1);
  if (collision_list.size() > 0){
    // fill in for loop through collision list
    // remove each coin and add 1 to score
    for (int i = 0; i < coins1.size(); i++)
    {
      for (Coin k : collision_list)
      {
        if (k == coins1.get(i))
        {
          
          //coinC.play();
          coins1.remove(i);
          score++;

        }
      }
    }
  } 
}

void collectHearts() {
 ArrayList<Heart> collision_list1 = checkCollisionListH(player,hearts);
  if (collision_list1.size() > 0){
    for (int i = 0; i < hearts.size(); i++)
    {
      for (Heart k : collision_list1)
      {
        if (k == hearts.get(i))
        {

          hearts.remove(i);
          lives++;
        }
      }
    }
  } 
}
  
 
void checkDeath() {
  boolean collideEnemy = false; 
  ArrayList<Enemy> arr = checkCollisionListE(player, enemies);
  if (arr.size() > 0) {
   collideEnemy = true; 
  }
  boolean fall = player.getBottom() > GROUND_LEVEL;
  if (collideEnemy || fall) {
   lives--; 
   if (lives == 0) {
     gameOver = true;
     //music.stop();
     //defeat.play();
   }
   else {
     player.center_x = 100;
     player.setBottom(GROUND_LEVEL);
   }
  }
  
  
}

void scroll(){
  
  // create and initialize left_boundary variable
  // Hint: left_boundary = view_x + LEFT_MARGIN
  float left_boundary = view_x + LEFT_MARGIN;
  // if player's left < left_boundary
  //     view_x -= (left_boundary - player's left); 
  if (player.getLeft() < left_boundary) {
    view_x -= left_boundary - player.getLeft();
  }

  
  
  // create and initialize right_boundary variable
  // Hint: right_boundary = view_x + width - RIGHT_MARGIN;
  float right_boundary = view_x + width - RIGHT_MARGIN;
  
  // if player's right > right_boundary
  //     view_x += player's right - right_boundary;    
  if (player.getRight() > right_boundary) {
   view_x += player.getRight() - right_boundary;  
  }
  
  

  // create and initialize top_boundary variable
  // Hint: top_boundary = view_y + VERTICAL_MARGIN;
  float top_boundary = view_y + VERTICAL_MARGIN;
  
  // if player's top < top_boundary
  //   view_y -= top_boundary - player's top;
  if (player.getTop() < top_boundary) {
   view_y -= top_boundary - player.getTop(); 
  }

  
  
  // create and initialize bottom_boundary variable
  // Hint: bottom_boundary = view_y + height - VERTICAL_MARGIN;
  float bot_boundary = view_y + height - VERTICAL_MARGIN;
  
  // if player's bottom > bottom_boundary
  //    view_y += player's bottom - bottom_boundary;
  if (player.getBottom() > bot_boundary)  {
   view_y += player.getBottom() - bot_boundary; 
  }
  
  // call translate(-view_x, -view_y)
  translate(-view_x,-view_y);

}


// returns true if sprite is one a platform.
public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  // move down say 5 pixels
  s.center_y += 5;

  // check to see if sprite collide with any walls by calling checkCollisionList
  ArrayList<Sprite> collision_list = checkCollisionList(s, walls);
  
  // move back up 5 pixels to restore sprite to original position.
  s.center_y -= 5;
  
  // if sprite did collide with walls, it must have been on a platform: return true
  // otherwise return false.
  return collision_list.size() > 0; 
}


// Use your previous solutions from the previous lab.

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  // add gravity to change_y of sprite
  s.change_y += GRAVITY;
  
  // move in y-direction by adding change_y to center_y to update y position.
  s.center_y += s.change_y;
  
  // Now resolve any collision in the y-direction:
  // compute collision_list between sprite and walls(platforms).
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  
  
  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }

  // move in x-direction by adding change_x to center_x to update x position.
  s.center_x += s.change_x;
  
  // Now resolve any collision in the x-direction:
  // compute collision_list between sprite and walls(platforms).   
  col_list = checkCollisionList(s, walls);

  

  if(col_list.size() > 0){
    Sprite collided = col_list.get(0);
    if(s.change_x > 0){
        s.setRight(collided.getLeft());
    }
    else if(s.change_x < 0){
        s.setLeft(collided.getRight());
    }
  }}

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}
public ArrayList<Enemy> checkCollisionListE(Sprite s, ArrayList<Enemy> list){
  ArrayList<Enemy> collision_list = new ArrayList<Enemy>();
  for(Enemy p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public ArrayList<Heart> checkCollisionListH(Sprite s, ArrayList<Heart> list){
  ArrayList<Heart> collision_list = new ArrayList<Heart>();
  for(Heart p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}

public ArrayList<Coin> checkCollisionList1(Player s, ArrayList<Coin> list){
  ArrayList<Coin> collision_list = new ArrayList<Coin>();
  for(Coin p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
    
  return collision_list;
}

void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("a")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("b") || values[col].equals("B")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("c")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
        
      }
      else if(values[col].equals("r")){
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("h")){
        Heart s = new Heart(heart, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        hearts.add(s);
      }
      else if(values[col].equals("g")){
        Coin coins = new Coin(gold, SPRITE_SCALE);
        coins.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        coins.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins1.add(coins);
      }
      else if(values[col].equals("0")){
        continue; 
      }
      else{
        
        int lengthGap = int(values[col]); 
        float bLeft =  col * SPRITE_SIZE;
        float bRight = bLeft + lengthGap * SPRITE_SIZE;
        Enemy enemy = new Enemy(spider, 50/72.0,bLeft, bRight);
        enemy.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;      
        enemy.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        
        enemies.add(enemy);
        
        
    }
    }
  }
}
 

void keyPressed(){
  if(keyCode == RIGHT || key == 'd'){
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT || key == 'a'){
    player.change_x = -MOVE_SPEED;
  }
  
  else if(key == ' ' && isOnPlatforms(player, platforms)){
    player.change_y = -JUMP_SPEED;
   
  }
  
  if(gameOver && key == ' ')
    {
      //victory.stop();
      //defeat.stop();
      setup();
    }
}

void keyReleased(){
  if(keyCode == RIGHT){
    player.change_x = 0;
  }
  else if(keyCode == LEFT){
    player.change_x = 0;
  }
}
