SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
Order by 3,4


--SELECT *
--FROM PortfolioProject..CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
Order by 1,2

--Viewing Total Cases vs Total Deaths
--Shows likelyhood of death in contracted in resident country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Deathpercentage
FROM CovidDeaths
WHERE location Like '%state%'
order by 1,2

--Viewing Total Cases vs Population
--Shows percentage of population that contracted Covid

SELECT location,date,total_cases,population,(total_cases/population)*100 as Casepercentage
FROM CovidDeaths
--WHERE location like '%state%'
order by 1,2

--Viewing Countries with highest infection rate compared to population

SELECT location,Population,MAX(total_cases)AS HighestinfectionCount,MAX(total_cases/population)*100 as Percentpopulationinfected
FROM CovidDeaths
--WHERE location like '%state%'
Group by population,location
order by 4 DESC

--Viewing Countries with highest death rate per population

SELECT location, MAX(cast(total_deaths as INT)) as Totaldeathcount
FROM CovidDeaths
--Where location like '%state%'
WHERE continent is not NULL
GROUP BY location
Order by 2 DESC

--BREAKING THINGS DOWN BY CONTINENT


--Viewing contients with highest death rate per population

SELECT continent, MAX(cast(total_deaths as INT)) as Totaldeathcount
FROM CovidDeaths
--Where location like '%state%'
WHERE continent is not null
GROUP BY continent
Order by 2 DESC




--GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths ,SUM (cast(new_deaths as int))/SUM
 (new_cases)*100 as Deathpercentage
FROM CovidDeaths
--Where location like '%state%'
WHERE continent is not null
--GROUP By date
order by 1,2



--Viewing Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location ORDER by dea.location, 
   dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From CovidVaccinations vac
JOIN CovidDeaths dea
	ON dea.location=vac.location 
	and dea.date=vac.date
WHERE Dea.continent is not null
order by 2,3


--USE CTE 

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, Rollingpeoplevaccinated) 
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location ORDER by dea.location, 
   dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From CovidVaccinations vac
JOIN CovidDeaths dea
	ON dea.location=vac.location 
	and dea.date=vac.date
WHERE Dea.continent is not null
--order by 2,3
)
SELECT *, (Rollingpeoplevaccinated/Population)*100
FROM PopvsVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population Int,
New_vaccinations Int,
Rollingpeoplevaccinated int
)





Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location ORDER by dea.location, 
   dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From CovidVaccinations vac
JOIN CovidDeaths dea
	ON dea.location=vac.location 
	and dea.date=vac.date
WHERE Dea.continent is not null
order by 2,3

SELECT *, (Rollingpeoplevaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating View to store date for later visualization

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,  SUM(cast(vac.new_vaccinations as INT)) OVER (Partition by dea.location ORDER by dea.location, 
   dea.date) as Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
From CovidVaccinations vac
JOIN CovidDeaths dea
	ON dea.location=vac.location 
	and dea.date=vac.date
WHERE Dea.continent is not null
--order by 2,3


SELECT *
FRom PercentPopulationVaccinated





