**Abortion exhibits a global legal-regulatory gradient with no converging ethical or legal framework** — 60+ sources across 7 regions. Legal regimes span total bans (13 US states, El Salvador, Honduras, Poland) to no-gestational-limit decriminalization (Canada, Netherlands, 9 US states + DC). Three axes of irreducible polarization: fetal-personhood vs bodily-autonomy, religious-vs-secular moral authority, state-paternalism vs individual-rights. A fourth axis — physician-oath vs patient-access — surfaces in the conscientious-objection regime present in ~80 countries, where the Hippocratic tradition of preserving life collides with professional duties of care, referral, and non-abandonment. No single ethical framework reconciles these across jurisdictions.

Pattern: region-liberalizes → religious-institution-resists → legal-patchwork

Implication: a global index mapping abortion law, clinical access, ethical frameworks, and public opinion by country — not a debate-resolution tool but a structured comparison instrument.

Data: schemas/seed.sql — 60+ sources, 8 meta-analyses, 35+ researchers, 20+ gaps.

---
id: MANIFEST.ABORTION
title: Abortion — Global Legal, Ethical, and Public-Health Index
summary: 60+ sources across 7 regions; legal regimes span total bans to no-limit decriminalization; three irreducible axes of polarization plus physician-oath axis
tags: [abortion, reproductive-rights, bioethics, global-health, law, cross-region, conscientious-objection]
tables: [per-region-summary, fundamentals, professional-oath-traditions, by-region, meta-analyses, gaps, key-researchers-by-region]
---

## Per-Region Summary

| Region | Status | Sources | Key Finding | CO Climate |
|--------|--------|---------|-------------|------------|
| NA | PASS | 10 | US post-Dobbs patchwork (13 states total ban); Canada decriminalized since 1988 with regional access disparities | US: 69% OB-Gyn programs report opposition; CO laws vary by state. Canada: no statutory CO right for abortion |
| EU | PASS | 12 | General liberalization trend, wide national variation; France constitutionalized 2024; Poland severely restricted 2020; Ireland legalized via referendum 2018 | Italy ~70% gynecologists object; Poland high CO rates create access crisis; UK statutory CO with limits (emergency exception); Scandinavia no codified CO right |
| LATAM | PASS | 7 | Green wave: Argentina (2020), Colombia (2022), Mexico (2023) liberalized; El Salvador/Honduras total bans; lawfare central to both progressive and conservative mobilization | CO widely used to block access even where legal; unregulated CO a documented barrier |
| MENA | PASS | 9 | All permit abortion to save mother's life; Islamic 120-day ensoulment rule shapes jurisprudence; Tunisia most liberal; Saudi policy allows mental-health exception not operationalized | Islamic medical ethics permits conscientious refusal; Saudi mental-health exception unoperationalized partly due to provider reluctance |
| SSA | PASS | 8 | Highest unsafe-abortion burden (70% global maternal deaths); 16.5% prevalence (33-country Bayesian study, n=367,881); Ethiopia, South Africa, Zambia more permissive | Provider shortages compounded by refusal; CO poorly regulated; access paradox |
| SA | PASS | 7 | India legal up to 24 weeks; sex-selective abortion persists (son preference, dowry); Nepal liberal; Pakistan restrictive; criminalization deters adolescents | CO not systematically documented; criminalization creates de facto refusal environment |
| EA | PASS | 7 | China: liberal since 1950s, ~30M sex-selective abortions estimated 1980-2020; Japan: legal, widely used as birth control; South Korea: decriminalized 2020 | CO rarely invoked; abortion framed as public health/national population tool rather than moral dilemma |

## Fundamentals

| ID | Concept | Source | Key idea |
|----|---------|--------|----------|
| F.BODILY.AUTONOMY | Bodily autonomy as rights foundation | Roe v. Wade (1973) / Planned Parenthood v. Casey (1992) | Right to privacy under 14th Amendment extends to abortion; state may not unduly burden pre-viability |
| F.FETAL.PERSONHOOD | Fetal right to life | Dobbs v. Jackson Women's Health (2022) | Constitution does not guarantee abortion right; fetal life interests returned to state determination |
| F.ISLAMIC.ENSOULMENT | 120-day ensoulment rule | Quran / Hadith (Bukhari) | Soul breathed into fetus at 120 days; abortion before this point permitted on certain grounds by most schools; Hanafi most permissive, Maliki most restrictive |
| F.CATHOLIC.NATURAL.LAW | Natural law absolute prohibition | Evangelium Vitae (1995) / Donum Vitae (1987) | Human life from conception; direct abortion intrinsically evil; no exception for rape or fetal anomaly |
| F.PUBLIC.HEALTH | Unsafe abortion as health crisis | WHO (2023) | 45% of abortions globally unsafe; unsafe abortion causes ~13% of maternal deaths; restrictive laws correlate with higher unsafe-abortion rates |
| F.GREEN.WAVE | Latin American feminist legal mobilization | CEDAW / Inter-American Court | Strategic lawfare by feminist coalitions using human-rights frameworks; Argentina/Colombia/Mexico liberalization via legislative + judicial channels |
| F.HIPPOCRATIC.OATH | Hippocratic Oath prohibition on abortion | Hippocratic Corpus (c. 5th-3rd c. BCE) / Queen's Univ. MA thesis (2022) | Original oath explicitly bans giving abortive pessary; reflected minority Pythagorean view, not ancient Greek medical consensus; clause removed from modern versions |

## Professional Oath Traditions

| ID | Oath / Code | Body | Stance on abortion | Key detail |
|----|-------------|------|--------------------|------------|
| OATH.HIPPOCRATIC.ORIG | Hippocratic Oath (original) | Hippocratic Corpus | Prohibits | "I will not give a woman a pessary to cause an abortion" — minority Pythagorean view, not ancient consensus |
| OATH.HIPPOCRATIC.MOD | Hippocratic Oath (modern versions) | Various medical schools | Silent | Abortion clause removed from nearly all modern adaptations; most omit the clause without replacement |
| OATH.GENEVA | Declaration of Geneva (1948/2017) | World Medical Association | Silent | "I will maintain the utmost respect for human life" — deliberately ambiguous; no explicit abortion stance |
| OATH.AMA | AMA Code of Medical Ethics | American Medical Association | Neutral | Recognizes abortion as legal medical procedure; physician may refuse but must arrange continuity of care |
| OATH.ACOG | ACOG Committee Opinion | American College of OB-Gyn | Supportive | "Safe, legal abortion is a necessary component of women's health"; CO must not impede access |
| OATH.ISLAMIC | Islamic medical ethics (Fiqh) | Various schools of jurisprudence | Conditional | Abortion permitted before 120 days on certain grounds; Hanafi most permissive; Maliki prohibits absolutely |
| OATH.CATHOLIC | Catholic medical ethics | Vatican (Evangelium Vitae) | Prohibits | Direct abortion intrinsically evil; Catholic hospitals often ban abortion even where legal |
| OATH.UK.STATUTE | UK Abortion Act 1967 s.4 | UK Parliament | Statutory CO right | "No person shall be under any duty to participate" — but emergency exception for saving life; referral required |
| OATH.WHO | WHO Abortion Care Guideline | World Health Organization | CO must not impede | CO permitted but must not delay/deny access; states must regulate to ensure coverage |

## By Region

### NA — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| NA.ROE | Roe v. Wade (1973) | US Supreme Court | Constitutional right to privacy protects abortion; overturned 2022 by Dobbs | EN |
| NA.DOBBS | Dobbs v. Jackson Women's Health (2022) | US Supreme Court | No federal right to abortion; returned to states; 13 trigger-ban states enacted total bans | EN |
| NA.KFF | Abortion in the United States Dashboard | KFF | 13 states total ban, 7 with 6-12 week limits, 18 at viability, 9+DC no limit (as of Mar 2026) | EN |
| NA.BALLOTPEDIA | Abortion regulations by state | Ballotpedia | 41 states restrict at specific stages; 11 ballot measures in 2024 election; 7 approved constitutional rights | EN |
| NA.CANADA.LEGAL | Abortion in Canada (health service) | Government of Canada | Abortion decriminalized 1988 (Morgentaler); publicly funded; no legal gestational limit; access varies by province | EN |
| NA.CANADA.HISTORY | Abortion rights in Canada | Courthouse Library BC | Criminalized 1869-1988; Morgentaler SCC decision; Canada Health Act covers as insured service | EN |
| NA.CANADA.DOULA | Abortion doula experiences in Ontario | Research Square (2025) | Gaps in care persist despite legality; stigma, rural access shortages, provider training deficits | EN |
| NA.PEW | Global abortion attitudes survey | Pew Research Center (2023-24) | 27 countries surveyed; 63% of US adults say legal all/most cases; Canada 80%+ support | EN |
| NA.ANESTHESIA.CO | Anesthesiologist refusal for abortion care | Anesthesia & Analgesia (2024) | 69% of OB-Gyn program directors faced opposition; 30% attributed to anesthesiologist refusal | EN |
| NA.UN.WGDAWG | UN Working Group on Discrimination guidance | UN WGDAWG (2025) | CO must not impede access; referral duty; emergency exceptions; ~80 countries allow CO | EN |

### EU — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| EU.REUTERS | Abortion laws in Europe overview | Reuters (2024) | General liberalization trend; Malta and Andorra most restrictive; Ireland referendum 2018 transformed | EN |
| EU.LEVELS | Review of abortion laws Western Europe 1960-2010 | Health Policy (2014) | Cross-national comparison; trend toward permissiveness but procedural barriers persist; highly detailed national variation | EN |
| EU.FRANCE | France constitutionalizes abortion (2024) | French Parliament / HRW | First country to enshrine abortion in constitution; law decriminalized 1975; limit extended to 14 weeks (2022) | EN |
| EU.POLAND | Poland Constitutional Tribunal (2020) | Polish Constitutional Tribunal | Abortion for fetal impairment ruled unconstitutional; near-total ban; mass protests; doctors reluctant to perform legal exceptions | EN |
| EU.GERMANY | German abortion law | Federal Constitutional Court (1975) | 12-week limit with mandatory counseling; court ruled unborn life has independent constitutional protection; balancing test | EN |
| EU.UK | UK Abortion Act 1967 | UK Parliament | 24-week limit; extends to Northern Ireland 2019; doctors authorize; EEF-linked research | EN |
| EU.PEW.EUROPE | Legal abortion support in Europe | Pew Research Center | 75%+ support in nearly every European country surveyed; Sweden 95%; Poland lowest at 56% | EN |
| EU.SPECTRUM | Spectrum of Choice: European abortion legislation | MDPI (2026) | Frameworks balance maternal autonomy, fetal protection, medical regulation; distinct regulatory models across jurisdictions | EN |
| EU.ECHR | Vo v. France (2004) | European Court of Human Rights | National discretion on when life begins; diversity of legal cultures; state has considerable margin of appreciation | EN |
| EU.IRISH.REF | Irish abortion referendum 2018 | Government of Ireland | 66% voted to repeal 8th Amendment; legalized up to 12 weeks; Savita Halappanavar case catalyzed reform | EN |
| EU.ITALY.CO | Conscientious objection in Italy | Multiple sources | ~70% of Italian gynecologists register as conscientious objectors; access severely limited in some regions | EN |
| EU.UK.CO.LAW | UK conscientious objection law | BPAS / GMC guidance | Abortion Act s.4 statutory CO; Supreme Court (2014) limited scope — does not extend to clerical/supervisory duties | EN |

### LATAM — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| LATAM.ARGENTINA | Argentina legalization 2020 | Argentine Congress | Legal up to 14 weeks; Green Wave movement; first major Latin American liberalization | ES |
| LATAM.COLOMBIA | Colombia constitutional ruling 2022 | Colombian Constitutional Court | Legal on demand up to 24 weeks; landmark ruling; decriminalized beyond that for 3 grounds | ES |
| LATAM.MEXICO | Mexico decriminalization 2023 | Supreme Court of Mexico | Federal penal code no longer criminalizes abortion; states must comply; gradual implementation | ES |
| LATAM.ELSALVADOR | El Salvador total ban | Legislative Assembly | Total ban since 1998; no exceptions for rape, incest, life threat; one of world's strictest | ES |
| LATAM.LAWFARE | Abortion Rights Lawfare in Latin America | CMI Norway (2014-2017) | Strategic use of rights and law by both progressive and conservative groups; transnational dimension | EN |
| LATAM.NATION | Latin America abortion rights revolution | The Nation / green wave reporting | Green wave: feminist mobilization via human rights frames; unexpected scale of liberalization | EN |
| LATAM.CO.REG | CO regulation in Latin America | REDAAS / multiple | CO used to block access even where legal; Colombia mandates non-objecting providers; Argentina requires referral | ES |

### MENA — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| MENA.LIMITS | Limits of the Law: Abortion in MENA | HHR Journal / CMI | All MENA countries permit to save mother's life; colonial-era penal codes persist; Maputo Protocol unratified by most | EN |
| MENA.ISLAMIC.ETHICS | Islamic ethics of abortion | The Conversation / multiple scholars | 120-day ensoulment as key threshold; no single Islamic interpretation; schools vary: Hanafi most permissive, Maliki most restrictive | EN |
| MENA.SAUDI | Islamic ethics and reproductive health policy in Saudi Arabia | BMC / PMC (2025) | Abortion permitted before 120 days for mental health but no operational protocols; 6 policy gaps identified | EN |
| MENA.TUNISIA | Tunisia abortion law | Global Abortion Policies Database | Most liberal in MENA; legal on request first trimester; post-colonial French civil law influence | EN |
| MENA.IRAN | Iran abortion law | Islamic Parliament of Iran | Legal for fetal impairment and maternal life risk; Shia jurisprudence; pre-ensoulment discretion | EN |
| MENA.SCHOOLS | Abortion in Islamic jurisprudence | IJHER (2022) | Hanafi: permitted pre-creation (120 days); Maliki: absolutely prohibited; Shafi'i/Hanbali: mixed | EN |
| MENA.HRW | International human rights law and abortion | Human Rights Watch | 122+ concluding observations on 93 countries by UN treaty bodies on abortion; right-to-health link | EN |
| MENA.COMPARISON | Saudi vs Alabama comparison | Quartz (2022) | Saudi law more permissive (120-day mental health exception) than Alabama total ban | EN |
| MENA.ISLAMIC.ETHICS.2 | Abortion as ethical-religious problem in Islam | Pharos Journal (2024) | Comprehensive survey of Islamic ethics on abortion across Sunni and Shia schools; legislative variation across Muslim countries | EN |

### SSA — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| SSA.SCOPING | Scoping review of abortion research in SSA | PLOS One (2021) | Uneven research distribution across countries; acute data shortages impede policy | EN |
| SSA.BAYESIAN | Pooled prevalence induced abortion SSA | Archives of Public Health (2025) | 16.5% prevalence among reproductive-age women; 33 countries, n=367,881; Bayesian multilevel model | EN |
| SSA.MORTALITY | Women's experiences abortion care SSA | PLOS One (2025) | 70% global maternal deaths in SSA; 77% of abortions unsafe in SSA vs 45% globally | EN |
| SSA.MAPUTO | Maputo Protocol (2003) | African Union | Recognizes abortion as human right for rape, incest, health risk; uneven ratification and implementation | EN |
| SSA.ACCESS | Access paradox: Ethiopia, Tanzania, Zambia | Int J Equity Health (2019) | Liberal laws coexisting with restricted access; stigma, provider shortages, infrastructure gaps | EN |
| SSA.SOUTH.AFRICA | Choice on Termination of Pregnancy Act (1996) | South African Parliament | Legal up to 12 weeks on request, 13-20 weeks under conditions; most liberal in SSA | EN |
| SSA.IMPACT | How research affects policy: 3-country study | East African Medical Journal (2004) | Policy advocacy requires evidence sharing with decision-makers; abortion complications as entry point | EN |
| SSA.CO.STIGMA | Why context matters: CO in SSA | Ibis / Global Public Health (2016) | Social, economic, and political pressures drive CO claims; stigma and low pay discourage provision | EN |

### SA — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| SA.INDIA | Medical Termination of Pregnancy Act 1971 (amended 2021) | Parliament of India | Legal up to 24 weeks; gestational limit extended; sex-selective abortion banned; ~10M female births lost | EN |
| SA.NEPAL | Nepal abortion law | Parliament / CRR | Legal on request up to 12 weeks; decriminalization via litigation; most liberal in South Asia | EN |
| SA.PAKISTAN | Pakistan Penal Code abortion provisions | Pakistan Parliament | Only to save mother's life; Islamic influence; high unsafe-abortion rates | EN |
| SA.SEX.SELECT | Sex-selective abortion in South and East Asia | Women's Studies Int Forum (2025) | Women's education has no clear relationship to sex-selective abortion; son preference persists across class | EN |
| SA.IPP.SOUTH | Abortion laws, rights and realities in South Asia | IPPF South Asia (2025) | Criminalization deters adolescents; rising anti-abortion opposition; aid cuts threaten services | EN |
| SA.GUTTMACHER | Abortion service provision South Asia comparative | Guttmacher Institute | 58-90% of abortions illegal even where permitted; postabortion treatment rates 4-26 per 1000 women | EN |
| SA.MTP.AMEND | MTP Amendment Act 2021 | Parliament of India | Extended gestational limit from 20 to 24 weeks; opinion of one provider for up to 20 weeks, two for 20-24 | EN |

### EA — PASS

| ID | Source | Institution | Key content | Language |
|----|--------|-------------|-------------|----------|
| EA.CHINA.SEX.SELECT | Sex-selective abortions over 4 decades in China | Population Health Metrics (2025) | ~30 million sex-selective abortions 1980-2020; peaked 1990-2010, declined since; 30M estimated total | EN |
| EA.CHINA.HISTORY | Abortion law liberalization | CFR / UN Population Division | Liberalized 1950s; widely promoted under one-child policy (1979-2015); sex ratio imbalance persists | EN |
| EA.JAPAN | Abortion in Japan | Japan Times / Mainichi | Legal with spousal consent up to 22 weeks; widely used as primary birth control method historically | EN |
| EA.KOREA | South Korea decriminalization (2020) | Constitutional Court of Korea | Abortion ban ruled unconstitutional (2019); decriminalized 2020; previously criminalized since 1953 | EN |
| EA.SON.PREF | Consequences of son preference and sex-selective abortion | CMAJ (2011) | SRB distortion in China, South Korea, India; policy approaches: ban sex selection and address son preference | EN |
| EA.FERTILITY | Fertility politics in East Asia | AsiaGlobal Online HKU | Reproductive technologies controlled by marriage requirement; bioethics vs biopolitics; state demographic concerns | EN |
| EA.LIBERALIZATION | East Asian abortion law reform | CFR global comparisons | China liberalized 1950s; South Korea decriminalized 2020; Japan allows up to 22 weeks with spousal consent | EN |

## Meta-analyses

| ID | Title | Scope | Key finding | Effect/size |
|----|-------|-------|-------------|-------------|
| MA.PEW | Global abortion attitudes 2023-24 | 27 countries, n=27,285 | Median 66% support legal abortion; Europe 75%+; Africa 9-30%; gender/ideology/religion divide | 66% median |
| MA.GUTTMACHER | Abortion service provision South Asia | 4-country facility survey 2012-2015 | 58-90% of abortions illegal even under broad criteria; postabortion treatment rate 4-26/1000 | 58-90% illegal |
| MA.BAYESIAN | Pooled prevalence induced abortion SSA | 33 countries, n=367,881 | 16.5% prevalence; region, education, wealth, smoking, birth interval significant factors | 16.5% |
| MA.SSA.SCOPING | SSA abortion research landscape | Electronic databases 2011-2021 | Uneven distribution; acute data shortages impede policy; English/French literature mapped | qualitative |
| MA.LEVELS | Western Europe abortion law trends 1960-2010 | 20 Western European countries | Consistent liberalization; procedural barriers persist under permissive laws; highly detailed variation | qualitative |
| MA.CHINA.SEX | Sex-selective abortions China 1980-2020 | National official statistics | 30M sex-selective abortions; second-order female fetuses largest proportion; peaked 1990-2010 | 30M |
| MA.ISLAMIC | Abortion in Islamic jurisprudence systematic | 4 Sunni schools + Shia | Hanafi most permissive (pre-120-days); Maliki absolute prohibition; Shia moderate | qualitative |
| MA.CONSECIENTIOUS | Impact of conscientious objection on abortion outcomes | Systematic review / Health Policy (2023) | CO associated with delay, stigma, refusal, inaccessibility; negative impacts on non-objecting providers | multi-study synthesis |

## Gaps

| ID | Region | Status | Notes |
|----|--------|--------|-------|
| GAP.OECD | OECD countries | surfaced | Comparative abortion data for OECD exists but not systematically indexed by ethical framework |
| GAP.EE | Eastern Europe | surfaced | Post-Soviet abortion regimes understudied in English-language literature; Russia/Belarus/Ukraine trends |
| GAP.CAUCASUS | Caucasus (Georgia, Armenia, Azerbaijan) | no sources | No indexed sources on abortion law + public health intersection |
| GAP.CARIBBEAN | Caribbean non-LATAM | no sources | Abortion laws in Jamaica, Trinidad, Barbados surface rarely in English databases |
| GAP.CENTRAL.ASIA | Central Asia (Kazakhstan, Uzbekistan, etc.) | no sources | Post-Soviet abortion regimes; likely liberal but no indexed sources found |
| GAP.OCEANIA | Pacific Island states | no sources | Abortion law in PNG, Fiji, Solomon Islands absent from search results |
| GAP.SSA.FRANCOPHONE | Francophone West Africa | surfaced | French-language sources likely exist but under-indexed in English databases |
| GAP.MENA.DATA | MENA official statistics | not surfaced | Most MENA states do not collect or publish abortion incidence data |
| GAP.LATAM.ANDES | Peru, Bolivia, Ecuador | surfaced | Moderate restrictions but region understudied relative to green wave countries |
| GAP.SEX.SELECT.EA | Sex-selective abortion measurement | surfaced | Direct measurement nearly impossible due to bans on sex determination; indirect methods only |
| GAP.DISABILITY | Abortion for fetal anomaly by jurisdiction | not surfaced | Cross-national comparison of disability-selective abortion laws absent from indexed literature |
| GAP.CONSCIENTIOUS | Conscientious objection regulation comparison | surfaced | Partial data exists (de Londras 2023, Chavkin 2013, UN WGDAWG 2025) but no comprehensive cross-regional CO rate survey with standardized methodology |
| GAP.ADOLESCENT | Adolescent abortion access barriers | surfaced | Legal barriers for minors (consent laws, mandatory reporting) understudied comparatively |
| GAP.INDIGENOUS | Indigenous women abortion access | not surfaced | No comparative study of abortion access for Indigenous populations across settler-colonial states |
| GAP.TELEMED | Telemedicine abortion impact | surfaced | Post-COVID telemedicine abortion expansion (USA, EU) not yet systematically compared across regions |
| GAP.SAFRICA.MENSTRUAL | Menstrual regulation self-care | not surfaced | Self-managed abortion data (WHO self-care recommendations) adoption by country not indexed |
| GAP.ISRAEL | Israel abortion law | surfaced | Israel has relatively liberal law (termination committee approval) but framed within demographic politics |
| GAP.SSB.SOUTHEAST | Southeast Asia (Thailand, Vietnam, Philippines, Indonesia) | surfaced | Thailand legalized 2021, Philippines restrictive, Indonesia restrictive; cross-national comparison needed |
| GAP.POST.ROE | Post-Dobbs US state tracking | surfaced | Rapidly shifting landscape; 11 ballot measures 2024; continuous tracking required |
| GAP.EU.ENLARGEMENT | EU candidate countries abortion law harmonization | not surfaced | How EU enlargement affects abortion law in candidate countries (Western Balkans, Turkey) |
| GAP.CO.OATH.TRACKING | Physician oath variants by country | not surfaced | No indexed global registry of which medical oaths include/omit abortion clauses, nor systematic tracking of how oath language correlates with CO rates |

## Key Researchers by Region

| Name | Region | Institution | Specialisation |
|------|--------|-------------|----------------|
| Mark Levels | EU | Radboud University | Cross-national European abortion law comparison (1960-2010) |
| Susheela Singh | SA | Guttmacher Institute | Abortion incidence and service provision in South Asia |
| Mahesh Puri | SA | CREHPA Nepal | Abortion service provision, Nepal reproductive health |
| Prabhat Jha | SA / EA | University of Toronto | Sex-selective abortion, missing women in India and China |
| Quanbao Jiang | EA | Xi'an Jiaotong University | Sex-selective abortion trends in China (30M estimate) |
| Rosie Peppin Vaughan | SA / EA | UCL Institute of Education | Women's education and sex-selective abortion in Asia |
| Therese Hesketh | EA | UCL / Zhejiang University | Son preference and sex ratio consequences in Asia |
| Kenneth Juma | SSA | African Population and Health Research Center | Abortion research scoping review for SSA |
| Boniface Ushie | SSA | African Population and Health Research Center | Abortion research priorities SSA, adolescent SRH |
| Setegn Muche Fenta | SSA | Bahir Dar University | Bayesian multilevel modelling of abortion prevalence in 33 SSA countries |
| Rachel Sieder | LATAM | CMI Norway | Abortion rights lawfare in Latin America, legal mobilization |
| Camila Gianella | LATAM | CMI / PUCP | Abortion lawfare, courts and social transformation |
| Sarrah Shahawy | MENA | Harvard / HHR | Abortion in MENA region, limits of law |
| Mohammed Ghaly | MENA | CILE / HBKU | Islamic bioethics, reproductive ethics |
| M. Al-Khatib | MENA | CILE / HBKU | Abortion in Hanbali jurisprudence, Islamic ethics |
| Mark J. Fromer | NA | — | Abortion ethics (1982 landmark nursing ethics article) |
| Joelle Proust | EU | ENS Paris / CSEN | Metacognition policy (ZPD connection also notable) |
| Fiona de Londras | Global | University of Birmingham | Conscientious objection impact on abortion outcomes (2023 systematic review) |
| Julian Savulescu | Global | Oxford / NUS | Bioethics: doctors have no right to refuse abortion (2017); conscientious commitment |
| Udo Schuklenk | Global | Queen's University | Conscientious objection in health care; professional obligations vs conscience |
| Alberto Giubilini | Global | Oxford Uehiro Centre | Conscientious commitment; professional justification for illegal abortion provision |
| Wendy Chavkin | Global | Columbia / Ibis Reproductive Health | International comparative CO regulation; context matters framework |
