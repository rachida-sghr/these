include "alldifferent.mzn";

%ensemble des vehicules therminques
int : nbreVehiculeThermique;
set of int: VehiculeThermiques = 1..nbreVehiculeThermique;
array[VehiculeThermiques] of int : identifiantVT;

%L'ensemble de tous les vehicules
set of int : lesVehicules;

% variables : quel vehicule affecter a quelle tournee
array[Tournees] of var lesVehicules : tourneeVehicule;
array[Tournees] of var 0..max(distanceTournee) : kmElec;

%Les contraintes minizinc sur les variables

%nbre de tournees
int : nbreTournee;
set of int : Tournees = 1..nbreTournee;
%distance de chaque tournee
array[Tournees] of int : distanceTournee;

%ensemble des vehicules electriques
int : nbreVehiculeElectrique;
set of int : VehiculeElectriques = 1..nbreVehiculeElectrique;
array[VehiculeElectriques] of int : identifiantVE;
%autonomie de chaque VE
array[VehiculeElectriques] of int : autonomie;
%niveau de batterie de chaque VE
array[VehiculeElectriques] of int : niveauBatterie;


% affectation d'un vehicule thermique et dans ce cas kmElec est nul
constraint forall(t in Tournees)(
	forall(vt in VehiculeThermiques)(
		tourneeVehicule[t] = identifiantVT[vt] -> kmElec[t] = 0
	)
);


% Un vehicule par tournee
constraint alldifferent(tourneeVehicule);
% L'autonomie et le niveau de batterie du VE sont suffisants pour effectuer la tournee
constraint forall(t in Tournees)(
	forall(ve in VehiculeElectriques)(
		(tourneeVehicule[t] = identifiantVE[ve]) -> 
		(	autonomie[ve] * niveauBatterie[ve] > distanceTournee[t]
		 /\ kmElec[t] = distanceTournee[t])
	)
);
%maximiser le nombre de km de tounrnee fait par les vehicules electriques
solve maximize sum([kmElec[t] | t in Tournees]);

int: dist_tournees = sum(t in Tournees)(distanceTournee[t])
int: dist_electrique = sum(t in Tournees)(kmElec[t])
int: dist_thermique = dist_tournees - dist_thermique

%affichage
output
[show("\nLes vehicules electriques parcourent "),
 show_int(dist_electrique),
 show(" km")] ++
[show("\nLes vehicules thermiques parcourent "),
 show_int(dist_thermique),
 show(" km")] ++
[show("\nLes affectations :")]++
[show("\nID  Tournee = ")]++[show_int(3, idTournee) ++ "  " | idTournee in Tournees, ]++[show("\n")]++
[show("\nDistTournee = ")]++[show_int(3, distanceTournee[t]) ++ "  " | t in Tournees, ]++[show("\n")]++
[show("\nID Vehicule = ")]++[show_int(3, tourneeVehicule[t]) ++ "  " | t in Tournees]
;

