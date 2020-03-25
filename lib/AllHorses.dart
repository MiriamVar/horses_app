import 'Horse.dart';

class AllHorses{
  List<Horse> horses = [];

  Horse _horse_1 = Horse("chipNum", "703001262600197","Nonius XX (N XIII-1) Jonatán","Nonius XX","Nonius XIII (N XLIV-78)","Nonius I-20", "žrebec", "nonius", "Hnedák","05-03-1997","",170, 161,190,0,3606,1997, 21.6);
  Horse _horse_2 =  Horse("chipNum", "703001783211006","Fakľa","","Annaberg Vulkan XIV s.v.","Fáva", "kobyla", "norik", "Tm.r","2006-03-07","hv.zuž.sa v n.pruh,prech.v ľstr.šň.,na hv.ryš.škvrna; ľ.st: SK/06",170, 159,205,0,4303,2006, 24.5);

  AllHorses(){
    addHorse(_horse_1);
    addHorse(_horse_2);
  }

   List<Horse> getHorses(){
     return this.horses;
  }

  void addHorse(Horse horse){
    horses.add(horse);
  }
}