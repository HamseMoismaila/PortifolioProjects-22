Select* from dbo.Coviddeaths$;


select Location, date, new_cases, total_cases,Total_deaths,population 
from dbo.Coviddeaths$
order by 1,2 


select * from dbo.CovidVacinated$
order by 3;



-- Total Death vs Total cases 

select Location, date, new_cases,Total_deaths 
from dbo.Coviddeaths$
order by 1,2 ;


--percentage of people who died 

--likehood of dying in your country 

select Location, date, total_cases, Total_deaths,( Total_deaths/ total_cases )*100 per_deaths
from dbo.Coviddeaths$
where location like 'Som%'
order by 1,2 ;

--- Totalcases vs population 


select Location, date, population, Total_cases 
from dbo.Coviddeaths$
order by 1,2 ;

-- percetage of people got Covid 
select Location, date, population, Total_cases,(Total_cases /population)*100 as Per_effected 
from dbo.Coviddeaths$
where location = 'somalia' and continent is not null
order by 1,2 ;

---what country have highst infection rate compare to papoultion 

select Location,population,max (total_cases ) as Highestiinfectioncount ,(max(total_cases/population)* 100)as Per_Highestinfection
from Covid_stat.dbo.Coviddeaths$
where continent is not null 
group by Location,population
order by Highestiinfectioncount  desc ;

--Country with highest death count per country--
select Location, max(cast (total_deaths as int)) as Totaldeathcount 
from Covid_stat.dbo.CovidDeaths$
where continent is not  null
group by location
order by Totaldeathcount desc;

--Lets look angles from continent --Location have continant and country but its accurate

select location, max(cast (total_deaths as int)) as Totaldeathcount 
from Covid_stat.dbo.CovidDeaths$
where continent is   null
group by location
order by Totaldeathcount desc;


--showing the continent with highest death count per population/ not Right 


select continent, max(cast (total_deaths as int)) as Totaldeathcount 
from Covid_stat.dbo.CovidDeaths$
where continent is not null
group by continent
order by Totaldeathcount desc


---GLOBAL NUMBERS 

select date, sum(new_cases) as total_cases, sum(cast(total_deaths as int)) as Total_deaths, (sum(cast(total_deaths as int))/sum(new_cases)*100) as Per_Deaths 
from Covid_stat.dbo.CovidDeaths$

where continent is not null
group by date
order by Date ;



select * from Covid_stat.dbo.CovidVacinated$;

select vac.date,vac.location,vac.positive_rate, dae.total_deaths 
from covid_stat.dbo.CovidVacinated$ vac
join covid_stat.dbo.CovidDeaths$ dae
on dae.location = vac.location
and dae.date = vac.date  
where positive_rate is not null


--NEMBER OF VACINATED PEOPLE PER country  


select location, population , max(cast ( people_vaccinated as int)) as TotalVacinated,  (population /max(cast ( people_vaccinated as int))) as PerVaccinatedcountry
from Covid_stat.dbo.CovidVacinated$
where continent is not null
group by location ,population 
order by 1,2 desc


--LOOKING TOTAL POPULATION VS VACINATED 


select dae.continent, dae.location,dae.date, vac.new_vaccinations,
sum(cast(vac.new_vaccinations) over (partition by dae.continent)
from covid_stat.dbo.CovidVacinated$ vac
join covid_stat.dbo.CovidDeaths$ dae
on dae.location = vac.location
and dae.date = vac.date  
where dae.continent is not  null
order by 2,3

--









With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated

--

