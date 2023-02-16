
Select *
From PortfolioProject1..CovidDeaths
Where continent is not Null


Select Location, date, total_cases total_deaths, population
From PortfolioProject1..CovidDeaths
Where continent is not Null
Order by 1,2


--'Looking at Total cases vs Deaths (Likelyhood of dying from Covid19)
Select Location, date, total_cases, total_deaths, population, (total_deaths/total_cases *100) as DeathPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
Order by 1,2

--Total Cases Vs Population (Shows percentage of Population that contracted Covid)
Select Location, date, total_cases, total_deaths, population, (total_cases/population *100) as CovidPercentage
From PortfolioProject1..CovidDeaths
Where location like '%states%'
Order by 1,2


--Countries with Highest Infection Rate
Select Location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population *100) as PopulationInfectionRate
From PortfolioProject1..CovidDeaths
Where continent 
Group by location, population
Order by 4 Desc


--Countries with Highest Death Count Per Population
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
Where continent is not Null
Group by location
Order by TotalDeathCount Desc



--Continent with Highest Death Rate Per Population
Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
Where continent is Null
Group by location
Order by TotalDeathCount Desc

--Continent with Highest Death Count Per Population
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths
Where continent is not Null
Group by continent
Order by TotalDeathCount Desc


--Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SuM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where Continent is not null
Group By date
order by 1,2

--Summary of Total Cases, Total Deaths and DeathPercentage
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SuM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
Where Continent is not null
order by 1,2

---Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVacinnations vac
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
Order by 2,3

-- CTE
With CTE_popvsvac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as

(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVacinnations vac
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null)

Select *, (RollingPeopleVaccinated/population) * 100
From CTE_popvsvac


--Temp Table
Drop Table If exists #PercentPopulationvaccinated
Create Table #PercentPopulationvaccinated
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVacinnations vac
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationvaccinated


--View to store data for later visualization
Create View PercentPopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVacinnations vac
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null


