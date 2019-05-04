unit uActionsMgr;

interface

type
  TActionInfo = packed record
    start: Word;// 开始帧
    frame: Word;// 帧数
    skip: Word;// 跳过的帧数
    ftime: Word; //每帧的延迟时间
  end;
  pTActionInfo = ^TActionInfo;

  // 玩家的动作定义
  THumanAction = record
    ActStand: TActionInfo; // 1
    ActWalk: TActionInfo; // 8
    ActRun: TActionInfo; // 8
    ActRushLeft: TActionInfo;
    ActRushRight: TActionInfo;
    ActWarMode: TActionInfo; // 1
    ActBatter: TActionInfo;
    ActHit: TActionInfo; // 6
    ActHeavyHit: TActionInfo; // 6
    ActBigHit: TActionInfo; // 6
    ActSpell: TActionInfo; // 6
    ActSitdown: TActionInfo; // 1
    ActStruck: TActionInfo; // 3
    ActDie: TActionInfo; // 4
    ActCircinate: TActionInfo;
    ActFireDragon: TActionInfo;
    ActSpurn: TActionInfo;
    ActSneak: TActionInfo;
    ActShamanHit: TActionInfo;
    ActShamanPush: TActionInfo;
    ActJumpHit : TActionInfo; //刺客起跳攻击
  end;
  pTHumanAction = ^THumanAction;

  TMonsterAction = record
    ActShow: TActionInfo;
    ActHide: TActionInfo;
    ActStand: TActionInfo;
    ActWalk: TActionInfo;
    ActAttack: TActionInfo;
    ActCritical: TActionInfo;
    ActStruck: TActionInfo;
    ActDie: TActionInfo;
    ActDeath: TActionInfo;
  end;
  pTMonsterAction = ^TMonsterAction;

  TMonActionManager = class

  end;

const
  // 人类动作定义
  // 每个人物每个级别每个性别共600幅图
  // 设级别=L，性别=S，则开始帧=L*600+600*S

  // Start:该动作在这组外观下的开始帧
  // frame:该动作需要的帧数
  // skip:跳过的帧数
  HA: THumanAction = ( // 开始帧       有效帧     跳过帧    每帧延迟
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200);  //站立
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 90);  //行走
    ActRun: (start: 128; frame: 6; skip: 2; ftime: 120); //跑
    ActRushLeft: (start: 128; frame: 3; skip: 5; ftime: 120);  //左冲锋
    ActRushRight: (start: 131; frame: 3; skip: 5; ftime: 120); //右冲锋
    ActWarMode: (start: 192; frame: 1; skip: 0; ftime: 200); // 挥刀冷却
        //刺客动作
    ActBatter: (start: 80; frame: 8; skip: 2; ftime: 60); //无用
    ActHit: (start: 200; frame: 6; skip: 2; ftime: 85); //攻击
    ActHeavyHit: (start: 264; frame: 6; skip: 2; ftime: 90); //重击
    ActBigHit: (start: 328; frame: 8; skip: 0; ftime: 70);//大击
    ActSpell: (start: 392; frame: 6; skip: 2; ftime: 60); //施法
    ActSitdown: (start: 456; frame: 2; skip: 0; ftime: 300);//挖取
    ActStruck: (start: 472; frame: 3; skip: 5; ftime: 70); //受击
    ActDie: (start: 536; frame: 4; skip: 4; ftime: 120); //死亡

    ActCircinate:(start: 616; frame:10; skip: 0; ftime: 80);  //右手攻击
    ActFireDragon:(start: 696; frame:6; skip: 2; ftime: 80); //炎龙波
    ActSpurn:(start: 760; frame:8; skip: 0; ftime: 80);    //旋风腿
    ActSneak:(start: 824; frame:6; skip: 2; ftime: 80);   //潜行
    ActShamanHit:(start: 600; frame:8; skip: 0; ftime: 80);  //武僧的攻击
    ActShamanPush:(start: 664; frame:6; skip: 2; ftime: 80);  //武僧的推人
    ActJumpHit:(start:328;frame:8;skip:0; ftime:100); //刺客起跳攻击

    );

  MA9: TMonsterAction = ( // 4C03D4
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200); ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120);
    ActAttack: (start: 64; frame: 6; skip: 2; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 64; frame: 6; skip: 2; ftime: 100); ActDie: (start: 0; frame: 1; skip: 7; ftime: 140);
    ActDeath: (start: 0; frame: 1; skip: 7; ftime: 0););
  MA10: TMonsterAction = ( // (8Frame) 带刀卫士
    // 每个动作8帧    //从这里可以推测出怪物有几种？//这里是280的
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200); ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120);
    ActAttack: (start: 128; frame: 4; skip: 4; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 192; frame: 2; skip: 0; ftime: 100); ActDie: (start: 208; frame: 4; skip: 4; ftime: 140);
    ActDeath: (start: 272; frame: 1; skip: 0; ftime: 0););
  MA11: TMonsterAction = ( // 荤娇(10Frame楼府)  //每个动作10帧 //280,(360的),440,430,,
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 120);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 140);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 0););
  MA12: TMonsterAction = ( // 版厚捍, 锭府绰 加档 狐福促.//每个动作8帧，每个动作8个方向，共7种动作 (280),360,440,430,,
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200); ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120);
    ActAttack: (start: 128; frame: 6; skip: 2; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 192; frame: 2; skip: 0; ftime: 150); ActDie: (start: 208; frame: 4; skip: 4; ftime: 160);
    ActDeath: (start: 272; frame: 1; skip: 0; ftime: 0););
  MA13: TMonsterAction = ( // mon2.wil中的食人花
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200);
    // 打开mon2.wil可以看到食人花,actstand是食人花站立状态
    ActWalk: (start: 10; frame: 8; skip: 2; ftime: 160);
    // actwalk实际上是食人花站出来或消隐的效果注意到花尾的泥土实际一些objects.wil里面也有泥土tiles
    // 石墓尸王钻出来时的地图效果，，食人花的效果跟暗龙相似，不知道暗龙的动作类型是不是也属于ma13
    ActAttack: (start: 30; frame: 6; skip: 4; ftime: 120);
    // actattack从30开始是从各个方位攻击的效果
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    // actcritical这个动作略去
    ActStruck: (start: 110; frame: 2; skip: 0; ftime: 100);
    // 受伤110开始，，
    ActDie: (start: 130; frame: 10; skip: 0; ftime: 120);
    // 130开始死亡效果
    ActDeath: (start: 20; frame: 9; skip: 0; ftime: 150);
    // 20开始是食人花消隐的效果也是它死亡效果所以在这重用，，只有9帧最后一帧略去
  );
  MA14: TMonsterAction = ( // 秦榜 坷付 mon3里面的骷髅战士,,分析方法同ma13
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 100); // 归榜牢版快(家券)
  );
  MA15: TMonsterAction = ( // 沃玛战土??新问题：源程序中对怪物的分类逻辑是不是就是mon*.wil的分类逻辑
    // 又注意到沃玛战士的五器没有,它带的可是海魂，，难道它也跟hum.wil一样要跟weapon.wil挂钩才能钩成完整的形象?
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 120);
    // die跟death有什么区别啊???一个是死亡开始，，一个是在地面上的残骸??但是按这样说下面的逻辑不对啊!!
    ActDeath: (start: 1; frame: 1; skip: 0; ftime: 100););
  MA16: TMonsterAction = ( // 啊胶筋绰 备单扁  mon5里面的电僵尸？？代表可移动的魔法攻击动作的怪物一类??
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 4; skip: 6; ftime: 160);
    ActDeath: (start: 0; frame: 1; skip: 0; ftime: 160););
  MA17: TMonsterAction = ( // 官迭波府绰 各  mon6中的和尚僵王（和石墓尸王共用一形象）
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 60); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 100);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140); //
  );
  MA19: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 140);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140); //
  );
  MA20: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 100);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 170););
  MA21: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 100); ActDie: (start: 30; frame: 10; skip: 0; ftime: 160);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA22: TMonsterAction = (ActStand: (start: 80; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 240; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100); ActDie: (start: 340; frame: 10; skip: 0; ftime: 160);
    ActDeath: (start: 0; frame: 6; skip: 4; ftime: 170););
  MA23: TMonsterAction = (ActStand: (start: 20; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 100; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 180; frame: 6; skip: 4; ftime: 100); //
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0); ActStruck: (start: 260; frame: 2; skip: 0; ftime: 100);
    ActDie: (start: 280; frame: 10; skip: 0; ftime: 160); ActDeath: (start: 0; frame: 20; skip: 0; ftime: 100););
  MA24: TMonsterAction = ( // (攻击) mon14中的蝎蛇??通过以下的分析好像又不是?
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 240; frame: 6; skip: 4; ftime: 100);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100); ActDie: (start: 340; frame: 10; skip: 0; ftime: 140);
    ActDeath: (start: 420; frame: 1; skip: 0; ftime: 140); //
  );
  MA25: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 70; frame: 10; skip: 0; ftime: 200);
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 10; frame: 6; skip: 4; ftime: 120);
    ActStruck: (start: 50; frame: 2; skip: 0; ftime: 100); ActDie: (start: 60; frame: 10; skip: 0; ftime: 200);
    ActDeath: (start: 80; frame: 10; skip: 0; ftime: 200););

  MA26: TMonsterAction = (ActStand: (start: 0; frame: 1; skip: 7; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 160);
    ActAttack: (start: 56; frame: 6; skip: 2; ftime: 500); ActCritical: (start: 64; frame: 6; skip: 2; ftime: 500);
    ActStruck: (start: 0; frame: 4; skip: 4; ftime: 100); ActDie: (start: 24; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 150););
  MA27: TMonsterAction = (ActStand: (start: 0; frame: 1; skip: 7; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 160);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 250); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 250);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 100); ActDie: (start: 0; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 150););
  MA28: TMonsterAction = (ActStand: (start: 80; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100););
  MA29: TMonsterAction = (ActStand: (start: 80; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 240; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100); ActDie: (start: 340; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100););
  MA30: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 10; skip: 0; ftime: 200);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 10; frame: 6; skip: 4; ftime: 120);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 100); ActDie: (start: 30; frame: 20; skip: 0; ftime: 150);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 200););
  MA31: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 10; skip: 0; ftime: 200);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 0; frame: 6; skip: 4; ftime: 120);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 100); ActDie: (start: 20; frame: 10; skip: 0; ftime: 200);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 200););
  MA32: TMonsterAction = (ActStand: (start: 0; frame: 1; skip: 9; ftime: 200); ActWalk: (start: 0; frame: 6; skip: 4; ftime: 200);
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 0; frame: 6; skip: 4; ftime: 120);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 100); ActDie: (start: 80; frame: 10; skip: 0; ftime: 80);
    ActDeath: (start: 80; frame: 10; skip: 0; ftime: 200););
  MA33: TMonsterAction = (
    // 开始帧    有效帧    跳过帧   每帧延迟
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200);
    // actstand是站立状态
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200); ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120);
    // actattack从30开始是从各个方位攻击的效果
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 120); ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 200); ActDeath: (start: 260; frame: 10; skip: 0; ftime: 200););
  MA34: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120); ActCritical: (start: 320; frame: 6; skip: 4; ftime: 120);
    ActStruck: (start: 400; frame: 2; skip: 0; ftime: 100); ActDie: (start: 420; frame: 20; skip: 0; ftime: 200);
    ActDeath: (start: 420; frame: 20; skip: 0; ftime: 200););
  MA35: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 30; frame: 10; skip: 0; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA36: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 30; frame: 20; skip: 0; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA37: TMonsterAction = (ActStand: (start: 30; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 30; frame: 4; skip: 6; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA38: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 80; frame: 6; skip: 4; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA39: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 300); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 150); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 150); ActDie: (start: 30; frame: 10; skip: 0; ftime: 80);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA40: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 250); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 210);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 110); ActCritical: (start: 580; frame: 20; skip: 0; ftime: 135);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 120); ActDie: (start: 260; frame: 20; skip: 0; ftime: 130);
    ActDeath: (start: 260; frame: 20; skip: 0; ftime: 130););
  MA41: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA42: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 10; frame: 8; skip: 2; ftime: 160);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0); ActDie: (start: 30; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 30; frame: 10; skip: 0; ftime: 150););
  MA43: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160); ActCritical: (start: 160; frame: 6; skip: 4; ftime: 160);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 150); ActDie: (start: 260; frame: 10; skip: 0; ftime: 120);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 100););
  MA44: TMonsterAction = (ActStand: (start: 0; frame: 10; skip: 0; ftime: 300); ActWalk: (start: 10; frame: 6; skip: 4; ftime: 150);
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 150); ActCritical: (start: 40; frame: 10; skip: 0; ftime: 150);
    ActStruck: (start: 40; frame: 2; skip: 8; ftime: 150); ActDie: (start: 30; frame: 6; skip: 4; ftime: 150);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA45: TMonsterAction = (ActStand: (start: 0; frame: 10; skip: 0; ftime: 300); ActWalk: (start: 0; frame: 10; skip: 0; ftime: 300);
    ActAttack: (start: 10; frame: 10; skip: 0; ftime: 300); ActCritical: (start: 10; frame: 10; skip: 0; ftime: 100);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 300); ActDie: (start: 0; frame: 1; skip: 9; ftime: 300);
    ActDeath: (start: 0; frame: 1; skip: 9; ftime: 300););
  MA46: TMonsterAction = (ActStand: (start: 0; frame: 20; skip: 0; ftime: 100); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  { MA47: TMonsterAction = (//4C0A4C 嗜血教主
    ActStand:(Start:0;  frame:4;  skip:6;  ftime:200);
    ActWalk:(Start:80;  frame:6;  skip:4;  ftime:200);
    ActAttack:(Start:160;  frame:6;  skip:4;  ftime:120);
    ActCritical:(Start:260;  frame:6;  skip:4;  ftime:120);
    ActStruck:(Start:240;  frame:2;  skip:0;  ftime:100);
    ActDie:(Start:524;  frame:6;  skip:0;  ftime:200);
    ActDeath:(Start:524;  frame:6;  skip:0;  ftime:200);
    ); }
  MA49: TMonsterAction = (ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160); ActCritical: (start: 340; frame: 6; skip: 4; ftime: 160);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 160);
    ActDeath: (start: 420; frame: 4; skip: 6; ftime: 200););
  MA50: TMonsterAction = ( // 雪域
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 60); ActWalk: (start: 0; frame: 10; skip: 0; ftime: 60);
    ActAttack: (start: 0; frame: 10; skip: 0; ftime: 60); ActCritical: (start: 0; frame: 10; skip: 0; ftime: 60);
    ActStruck: (start: 0; frame: 10; skip: 0; ftime: 60); ActDie: (start: 0; frame: 10; skip: 0; ftime: 60);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 60););
  MA51: TMonsterAction = ( // 雪域
    ActStand: (start: 0; frame: 1; skip: 0; ftime: 60); ActWalk: (start: 0; frame: 1; skip: 0; ftime: 60);
    ActAttack: (start: 0; frame: 1; skip: 0; ftime: 60); ActCritical: (start: 0; frame: 1; skip: 0; ftime: 60);
    ActStruck: (start: 0; frame: 1; skip: 0; ftime: 60); ActDie: (start: 0; frame: 1; skip: 0; ftime: 60);
    ActDeath: (start: 0; frame: 1; skip: 0; ftime: 60););
  MA61: TMonsterAction = ( // 新年树
    ActStand: (start: 0; frame: 20; skip: 0; ftime: 200); ActWalk: (start: 0; frame: 20; skip: 0; ftime: 200);
    ActAttack: (start: 0; frame: 20; skip: 0; ftime: 200); ActCritical: (start: 0; frame: 20; skip: 0; ftime: 200);
    ActStruck: (start: 0; frame: 20; skip: 0; ftime: 200); ActDie: (start: 0; frame: 20; skip: 0; ftime: 200);
    ActDeath: (start: 0; frame: 20; skip: 0; ftime: 200););
  MA63: TMonsterAction = ( // 圣诞老人
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 4; skip: 6; ftime: 200);
    ActAttack: (start: 0; frame: 4; skip: 6; ftime: 200); ActCritical: (start: 0; frame: 4; skip: 6; ftime: 200);
    ActStruck: (start: 0; frame: 4; skip: 6; ftime: 200); ActDie: (start: 0; frame: 4; skip: 6; ftime: 200);
    ActDeath: (start: 0; frame: 4; skip: 6; ftime: 200););
  MA70: TMonsterAction = ( // 卧龙笔记NPC
    ActStand: (start: 0; frame: 4; skip: 0; ftime: 200); ActWalk: (start: 0; frame: 4; skip: 0; ftime: 200);
    ActAttack: (start: 0; frame: 4; skip: 0; ftime: 200); ActCritical: (start: 0; frame: 4; skip: 0; ftime: 200);
    ActStruck: (start: 0; frame: 4; skip: 0; ftime: 200); ActDie: (start: 0; frame: 4; skip: 0; ftime: 200);
    ActDeath: (start: 0; frame: 4; skip: 0; ftime: 200););
  MA71: TMonsterAction = ( // 酒馆3个人物NPC 20080308
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 10; frame: 19; skip: 0; ftime: 200); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA93: TMonsterAction = ( // 雷炎蛛王 200808012
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 340; frame: 10; skip: 0; ftime: 160);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 160);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA94: TMonsterAction = ( // 雪域寒冰魔、雪域灭天魔、雪域五毒魔
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100); ActDie: (start: 260; frame: 10; skip: 0; ftime: 160);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA95: TMonsterAction = ( // 火龙守护兽
    ActStand: (start: 3; frame: 1; skip: 0; ftime: 0); ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 8; frame: 10; skip: 2; ftime: 160); ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0); ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0););
  MA100: TMonsterAction = ( // 月灵
    ActStand: (start: 360; frame: 4; skip: 6; ftime: 200); ActWalk: (start: 440; frame: 6; skip: 4; ftime: 200);
    ActAttack: (start: 520; frame: 6; skip: 4; ftime: 160);

    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0); ActStruck: (start: 600; frame: 2; skip: 0; ftime: 100); // 受攻击
    ActDie: (start: 620; frame: 6; skip: 4; ftime: 130); ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100););

  MA111: TMonsterAction = (
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActAttack: (start: 30; frame: 10; skip: 0; ftime: 150);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0);
  );
  MA112: TMonsterAction = (//酒鬼，无攻击
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160); //
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 150);
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 100);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 140);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140); //
  );
  MAGate:  TMonsterAction = ( // 雪域
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActAttack: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActCritical: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActStruck: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActDie: (start: 0; frame: 10; skip: 0; ftime: 100);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100);
  );
  MAGate1:  TMonsterAction = ( // 雪域
    ActStand: (start: 0; frame: 6; skip: 4; ftime: 100);
    ActWalk: (start: 0; frame: 6; skip: 4; ftime: 100);
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 100);
    ActCritical: (start: 0; frame: 6; skip: 4; ftime: 100);
    ActStruck: (start: 0; frame: 6; skip: 4; ftime: 100);
    ActDie: (start: 0; frame: 6; skip: 4; ftime: 100);
    ActDeath: (start: 0; frame: 6; skip: 4; ftime: 100);
  );


  { ------------------------------------------------------------------------------ }
  // 武器绘制顺序 (是否先于身体绘制: 0是/1否)
  // WEAPONORDERS: array [Sex, FrameIndex] of Byte
  { ------------------------------------------------------------------------------ }
  WORDER: Array [0 .. 1, 0 .. 887] of byte = ( // 1: 女,  0: 男
    // 第一维是性别，第二维是动作图片索引
    ( // 男
    // 站
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
    1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
    // 走
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    // 跑
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    // war葛靛
    0, 1, 1, 1, 0, 0, 0, 0,
    // 击
    1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1,
    // 击 2
    0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1,
    1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1,
    // 击3
    1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1,
    0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    // 付过
    0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0,
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1,
    0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1,
    // 澵扁
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0,
    // 嘎扁
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    // 静矾咙
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    //刺客
    1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,1,0,0,0,0,0,1,1,0,0,1,0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,
    0,0,0,1,0,0,1,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,1,0,0,0,0,1,0,1,
    1,0,0,0,0,1,0,0,1,1,0,0,0,1,0,0,1,1,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
    ),
    (
    // 沥瘤
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
    1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
    // 叭扁
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    // 顿扁
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    // war葛靛
    1, 1, 1, 1, 0, 0, 0, 0,
    // 傍拜
    1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1,
    // 傍拜 2
    0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1,
    1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1,
    // 傍拜3
    1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1,
    0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    // 付过
    0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0,
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1,
    0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1,
    // 澵扁
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0,
    // 嘎扁
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    // 静矾咙
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1,
    1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    //刺客
    1,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,1,0,0,0,0,0,1,1,0,0,1,0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,0,
    0,0,0,1,0,0,1,0,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,1,1,0,0,0,0,1,0,1,
    1,0,0,0,0,1,0,0,1,1,0,0,0,1,0,0,1,1,0,0,0,0,1,0,1,1,1,1,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0
    ));
var
WORDER_CKR : Array[0..1,0..887] of Byte = (
(
0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,
0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,
1,0,1,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,
1,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,1,0,1,0,0,
0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,0,0,1,1,1,1,1,0,0,0,
1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,0,1,1,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,
1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,
0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,0,0,0,1,0,0,0,1,1,1,1,
1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,1,1,1,0,0,0,0,
0,0,1,0,1,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,1,0,0,0,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,
1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
0,0,0,0,0,0,0,0),
(
0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,
0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,
1,0,1,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,
1,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,1,0,1,0,0,
0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,0,0,1,1,1,1,1,0,0,0,
1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,0,1,1,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,
1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,
0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,0,0,0,1,0,0,0,1,1,1,1,
1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,1,1,1,0,0,0,0,
0,0,1,0,1,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,1,0,0,0,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,
1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
0,0,0,0,0,0,0,0
));



WORDER_CKL : Array[0..1,0..887] of Byte = (
(
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,
1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,
0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,
1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,1,0,0,1,1,0,1,1,0,0,0,
1,1,0,1,1,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,
1,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,0,0,1,1,0,1,1,0,0,0,0,1,1,0,1,0,0,1,1,0,0,1,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,
1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,
1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,0,
0,0,1,1,1,1,0,0,1,0,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,
1,1,0,0,0,0,1,0,0,1,1,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1,0,1,1,1,0,0,1,0,0,1,1,1,0,0,
1,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,
1,0,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0,1,0,0,1,1,1,
0,0,1,0,0,0,1,0,0,0,1,1,0,0,0,0,1,0,0,1,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
1,1,1,1,1,1,0,0),
(
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,
1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,
0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,
1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,1,0,0,1,1,0,1,1,0,0,0,
1,1,0,1,1,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,
1,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,0,0,1,1,0,1,1,0,0,0,0,1,1,0,1,0,0,1,1,0,0,1,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,0,0,0,0,0,
1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,
1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,0,
0,0,1,1,1,1,0,0,1,0,1,1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,
1,1,0,0,0,0,1,0,0,1,1,0,0,0,1,1,0,0,0,0,1,1,0,0,1,1,0,1,1,1,0,0,1,0,0,1,1,1,0,0,
1,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,
1,0,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,0,1,0,0,1,1,1,
0,0,1,0,0,0,1,0,0,0,1,1,0,0,0,0,1,0,0,1,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
1,1,1,1,1,1,0,0
));



var
     //弓箭手
WORDER_ARCHER : Array[0..1,0..887] of Byte = (
(
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,
1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,
0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,
1,0,1,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,
1,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,1,0,1,0,0,
0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,0,0,1,1,1,1,1,0,0,0,
1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,0,1,1,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,
1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,
0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,0,0,0,1,0,0,0,1,1,1,1,
1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,1,1,1,0,0,0,0,
0,0,1,0,1,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,1,0,0,0,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,
1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
0,0,0,0,0,0,0,0),
(
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,
1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,
0,0,0,1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,1,0,0,1,1,1,0,0,1,0,0,
1,0,1,1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,
1,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,1,0,0,1,1,1,0,0,1,0,0,0,0,1,1,0,1,0,0,
0,0,1,1,1,1,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,0,0,0,1,1,1,1,1,0,0,0,
1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,1,0,1,0,0,1,1,1,1,0,1,1,0,1,1,0,1,0,1,1,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
1,1,1,1,1,1,0,0,0,0,0,1,1,1,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,
1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,
0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,
0,0,0,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,0,1,1,1,1,0,0,0,1,0,0,0,1,1,1,1,
1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,1,1,1,0,0,0,0,
0,0,1,0,1,1,0,0,0,0,1,0,0,0,0,0,1,0,1,1,1,0,0,0,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,
1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,
0,0,0,0,0,0,0,0
));



implementation

end.
