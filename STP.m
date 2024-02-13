function Pow = STP(STlev, kg, D)

%Storage power output in kW

    STlev = STlev.*kg;
    Pow = STlev/D.ts;
    STPaux = D.STPpeak(ones(D.NDn,1),:).*kg;
    Pow(Pow > STPaux) = STPaux(Pow > STPaux);

end
