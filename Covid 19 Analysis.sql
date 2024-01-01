create database Project_portfolio
use Project_portfolio

select * from coviddeath
select * from covidvaccination

select location, date, total_cases, new_cases, total_deaths, population from coviddeath
order by 1,2

/*Looking at Total Cases vs. Total Deaths 
and show likelihood of dying people in your country*/
SELECT location, date, total_cases, total_deaths, CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths)
/ CONVERT(DECIMAL(18, 2), total_cases)))*100 AS DeathPercentage
FROM CovidDeath where location like '%states%'
ORDER BY 1, 2

/*Looking at Total Cases vs. Population*/
Select location, date, population, total_cases, convert(decimal(18,2),
(convert(decimal(18,2),total_cases)/ convert(decimal(18,2),Population)))*100 as
Deaths_Percentage from coviddeath where location like 'India%' order by 1,2

/*Looking at countries with highest infection rate compared to population*/
select location, population , max(total_cases) as Highest_InfectedCount, convert(decimal(18,2), 
(convert(decimal(18,2),max(total_cases)/convert(decimal(18,2),max(population)))))*100 as
PercentagePopulationInfected from coviddeath group by location, population 
order by PercentagePopulationInfected desc

/*Showing countries with highest death count as per population. */
select location, max(cast(total_deaths as int)) as TotalDeathCount from coviddeath 
where continent is not null group by location order by TotalDeathCount desc

---select  sum(cast(total_cases as bigint)) from coviddeath --

/*Showing continents with highest death count per population. */
select continent , max(cast(total_deaths as int)) as TotalDeathCount from coviddeath 
where continent is not null group by continent order by TotalDeathCount


/* Global Number */
select sum(new_cases) as TotalCases , sum(cast(new_deaths as int)) as TotalDeaths,
sum(cast(new_deaths as int)) / nullif(sum(new_cases),0) *100 as DeathPercentage
from coviddeath where continent is not null 
order by 1,2


/*Looking at total Population vs Vaccination */
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) over(partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
from coviddeath dea inner join covidvaccination vac on dea.location=
vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) over(partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
from coviddeath dea inner join covidvaccination vac on dea.location=
vac.location and dea.date = vac.date
where dea.continent is not null
)
select *,(RollingPeopleVaccinated/population)*100
as RollingPeoplePercent from PopvsVac


--view--
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(decimal, vac.new_vaccinations)) over(partition by dea.location order by dea.location
,dea.date) as RollingPeopleVaccinated
from coviddeath dea inner join covidvaccination vac on dea.location=
vac.location and dea.date = vac.date
where dea.continent is not null

select * from PercentPopulationVaccinated



