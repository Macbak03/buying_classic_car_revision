;;; ***************************
;;; * DEFTEMPLATES & DEFFACTS *
;;; ***************************

(deftemplate UI-state
   (slot id (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted (default none))
   (slot response (default none))
   (multislot valid-answers)
   (slot state (default middle)))

(deftemplate state-list
   (slot current)
   (multislot sequence))

(deffacts startup
   (state-list))

;;;****************
;;;* STARTUP RULE *
;;;****************

(defrule system-banner
  =>
  (assert (UI-state (display BuyingClassCarRevision)
                    (relation-asserted start)
                    (state initial)
                    (valid-answers))))

;;;***************
;;;* QUERY RULES *
;;;***************

;; ROOT
(defrule determine-want-classic
   (logical (start))
   =>
   (assert (UI-state (display qWantClassic)
                     (relation-asserted want-classic)
                     (response aBoredom)
                     (valid-answers aBoredom aStatement aNoSoul aStyle aSpeedSafety))))

;; ---- Left branch: boredom
(defrule determine-why-boredom
   (logical (want-classic aBoredom))
   =>
   (assert (UI-state (display qWhyBoredom)
                     (relation-asserted why-boredom)
                     (response aHowCarsWork)
                     (valid-answers aHowCarsWork aEroticallyDrawn))))

(defrule determine-really-simple
   (logical (why-boredom aHowCarsWork))
   =>
   (assert (UI-state (display qReallySimple)
                     (relation-asserted really-simple)
                     (response aSoundGood)
                     (valid-answers aSoundGood aNotArchaic aMoreArchaic))))

(defrule determine-pretty-quick
   (logical (why-boredom aEroticallyDrawn))
   =>
   (assert (UI-state (display qPrettyQuick)
                     (relation-asserted pretty-quick)
                     (response Yes)
                     (valid-answers Yes aLovely))))

;; ---- Middle left branch: statement
(defrule determine-what-statement
   (logical (want-classic aStatement))
   =>
   (assert (UI-state (display qWhatStatement)
                     (relation-asserted what-statement)
                     (response aReallyRich)
                     (valid-answers
                       aReallyRich
                       aNycThemedDiner
                       aDistinctLuggage
                       aMothership
                       aLiveDangerously
                       aKook
                       aDrivingSeriously
                       aRefugee
                       aHatePeopleKnowing
                       aAutomotiveSubculture
                       aWallet
                       aMotorcycle))))

(defrule determine-faster
   (logical (what-statement aDistinctLuggage))
   (not (faster ?))
   =>
   (assert (UI-state (display qFaster)
                     (relation-asserted faster)
                     (response No)
                     (valid-answers No Yes))))

(defrule determine-even-faster
   (logical (what-statement aDistinctLuggage))
   (logical (faster Yes))
   (not (even-faster ?))
   =>
   (assert (UI-state (display qEvenFaster)
                     (relation-asserted even-faster)
                     (response No)
                     (valid-answers No Yes))))

;; ---- Middle right branch: style
(defrule determine-what-kind-of-style
   (logical (want-classic aStyle))
   =>
   (assert (UI-state (display qWhatKindOfStyle)
                     (relation-asserted what-kind-of-style)
                     (response aAfricanDictator)
                     (valid-answers
                       aAfricanDictator
                       aLoveCorvairs
                       aBuckRoger
                       aLoveChrome
                       aSlowCars
                       aLoveBrass
                       aMuseumWorthy
                       aWorkingClass
                       aClassicGerman))))

(defrule determine-hat
   (logical (what-kind-of-style aWorkingClass))
   =>
   (assert (UI-state (display qHat)
                     (relation-asserted hat)
                     (response aFriend)
                     (valid-answers aFriend aLostHat No))))

(defrule determine-tires
   (logical (hat No))
   =>
   (assert (UI-state (display qTires)
                     (relation-asserted tires)
                     (response aNoiseSmokeAnd)
                     (valid-answers aNoiseSmokeAnd aNoiseSmoke))))

;; ---- Right branch: speed

(defrule determine-real-speed
   (logical (want-classic aSpeedSafety))
   =>
   (assert (UI-state (display qRealSpeed)
                     (relation-asserted real-speed)
                     (response aFake)
                     (valid-answers aFake aDeathWish aLoveSpeed aFastCheap))))

(defrule determine-how-go
   (logical (real-speed aDeathWish))
   =>
   (assert (UI-state (display qHowGo)
                     (relation-asserted how-go)
                     (response aTinySpace)
                     (valid-answers aTinySpace aElectrocuted aBlazeOfGlory aCarTree aTalent))))

(defrule determine-who-are-you
   (logical (real-speed aLoveSpeed))
   =>
   (assert (UI-state (display qWhoAreYou)
                     (relation-asserted who-are-you)
                     (response aChildhoodPosters)
                     (valid-answers aDuke aChildhoodPosters aWeirdFetish))))

;; ---- Right branch: soul
(defrule determine-soul
   (logical (want-classic aNoSoul))
   =>
   (assert (UI-state (display qSoul)
                     (relation-asserted soul)
                     (response aEasy)
                     (valid-answers
                       aEasy
                       aSynonym
                       aNovel
                       aSoulHonestJob
                       aSofa
                       aCarStarring
                       aPureEvil
                       aSoulIsTheSpirit
                       aLucasElectrics))))

(defrule determine-like-what
   (logical (soul aNovel))
   =>
   (assert (UI-state (display qLikeWhat)
                     (relation-asserted like-what)
                     (response aPistons)
                     (valid-answers aPistons aEngineWrongPlace aCanBurn aBuildingPlane))))

(defrule determine-fast-fwd-sofa
   (logical (soul aSofa))
   =>
   (assert (UI-state (display qHugeFastSofa)
                     (relation-asserted fast-fwd-sofa)
                     (response Yes)
                     (valid-answers Yes No))))

;;;****************
;;;* Results *
;;;****************

;; really-simple -> results
(defrule result-more-archaic
  (logical (really-simple aMoreArchaic))
  =>
  (assert (UI-state (display cFordModelT) (state final))))

(defrule result-not-archaic
  (logical (really-simple aNotArchaic))
  =>
  (assert (UI-state (display cFordModelA) (state final))))

(defrule result-sounds-good
  (logical (really-simple aSoundGood))
  =>
  (assert (UI-state (display cSetSoundsGood) (state final))))


;; pretty-quick
(defrule result-pretty-quick
  (logical (pretty-quick Yes))
  =>
  (assert (UI-state (display cLotusElan) (state final))))

(defrule result-lovely
  (logical (pretty-quick aLovely))
  =>
  (assert (UI-state (display cAlfaRomeoGiuliaSuper) (state final))))


;; statements
(defrule result-really-rich
  (logical (what-statement aReallyRich))
  =>
  (assert (UI-state (display cVWType2Microbus) (state final))))

(defrule result-nyc-themed-diner
  (logical (what-statement aNycThemedDiner))
  =>
  (assert (UI-state (display cCheckerMarathon) (state final))))

(defrule result-type-iii
  (logical (faster No))
  =>
  (assert (UI-state (display cVWTypeIII) (state final)))) ;********************

(defrule result-porsche-914
  (logical (even-faster No))
  =>
  (assert (UI-state (display cPorsche914) (state final)))) ;**********************

(defrule result-mangusta
  (logical (even-faster Yes))
  =>
  (assert (UI-state (display cDeTomasoMangusta) (state final)))) ;***************************

(defrule result-mothership
  (logical (what-statement aMothership))
  =>
  (assert (UI-state (display cCitroen5M) (state final))))

(defrule result-live-dangerously
  (logical (what-statement aLiveDangerously))
  =>
  (assert (UI-state (display cChevyCorvair) (state final))))

(defrule result-kook
  (logical (what-statement aKook))
  =>
  (assert (UI-state (display cSetKook) (state final))))

(defrule result-driving-seriously
  (logical (what-statement aDrivingSeriously))
  =>
  (assert (UI-state (display cSetDrivingSeriously) (state final))))

(defrule result-refugee
  (logical (what-statement aRefugee))
  =>
  (assert (UI-state (display cTatraT87) (state final))))

(defrule result-hate-people-knowing
  (logical (what-statement aHatePeopleKnowing))
  =>
  (assert (UI-state (display cSetHatePeopleKnowing) (state final))))

(defrule result-automotive-subculture
  (logical (what-statement aAutomotiveSubculture))
  =>
  (assert (UI-state (display cSetAutomotiveSubculture) (state final))))

(defrule result-motorcycle
  (logical (what-statement aMotorcycle))
  =>
  (assert (UI-state (display cLotus7) (state final))))

(defrule result-wallet
  (logical (what-statement aWallet))
  =>
  (assert (UI-state (display cSetWalletOnChain) (state final))))


;; style
(defrule result-african-dictator
  (logical (what-kind-of-style aAfricanDictator))
  =>
  (assert (UI-state (display cMercedesBenz600) (state final))))

(defrule result-love-corvairs
  (logical (what-kind-of-style aLoveCorvairs))
  =>
  (assert (UI-state (display cNSUPrinz) (state final))))

(defrule result-buck-roger
  (logical (what-kind-of-style aBuckRoger))
  =>
  (assert (UI-state (display cCadillacEldorado59) (state final))))

(defrule result-chrome
  (logical (what-kind-of-style aLoveChrome))
  =>
  (assert (UI-state (display cChevyBelAir57) (state final))))

(defrule result-slow-cars
  (logical (what-kind-of-style aSlowCars))
  =>
  (assert (UI-state (display cSetSlowCars) (state final))))

(defrule result-love-brass
  (logical (what-kind-of-style aLoveBrass))
  =>
  (assert (UI-state (display cSetLoveBrass) (state final))))

(defrule result-museum-worthy
  (logical (what-kind-of-style aMuseumWorthy))
  =>
  (assert (UI-state (display cSetMuseumWorthy) (state final))))

(defrule result-classic-german
  (logical (what-kind-of-style aClassicGerman))
  =>
  (assert (UI-state (display cAudi100) (state final))))

(defrule result-faster-no
  (logical (faster No))
  =>
  (assert (UI-state (display cVWTypeIII) (state final))))

(defrule result-even-faster-no
  (logical (even-faster No))
  =>
  (assert (UI-state (display cPorsche914) (state final))))

(defrule result-mangusta-final
  (logical (even-faster Yes))
  =>
  (assert (UI-state (display cDeTomasoMangusta) (state final))))

;; hat
(defrule result-friend
  (logical (hat aFriend))
  =>
  (assert (UI-state (display cChevyCamaro) (state final))))

(defrule result-lost-hat
  (logical (hat aLostHat))
  =>
  (assert (UI-state (display cAmcAMX) (state final))))


;; tires
(defrule result-noise-smoke
  (logical (tires aNoiseSmoke))
  =>
  (assert (UI-state (display cSetNoiseSmoke) (state final))))

(defrule result-noise-smoke-and
  (logical (tires aNoiseSmokeAnd))
  =>
  (assert (UI-state (display cFoxBodyMustang) (state final))))



;; real speed
(defrule result-fast-cheap
  (logical (real-speed aFastCheap))
  =>
  (assert (UI-state (display cDodgeOmniGLH) (state final))))

(defrule result-fake
  (logical (real-speed aFake))
  =>
  (assert (UI-state (display cSetFake) (state final))))

;; want to go
(defrule result-tiny-space
  (logical (how-go aTinySpace))
  =>
  (assert (UI-state (display cSunbeamTiger) (state final))))

(defrule result-electrocuted
  (logical (how-go aElectrocuted))
  =>
  (assert (UI-state (display cJaguarEType) (state final))))

(defrule result-blaze-of-glory
  (logical (how-go aBlazeOfGlory))
  =>
  (assert (UI-state (display cFerrariTestarossa) (state final))))

(defrule result-car-tree
  (logical (how-go aCarTree))
  =>
  (assert (UI-state (display cSetCarTree) (state final))))

(defrule result-talent
  (logical (how-go aTalent))
  =>
  (assert (UI-state (display cPorscheSpyder) (state final))))

;; who are you
(defrule result-duke
  (logical (who-are-you aDuke))
  =>
  (assert (UI-state (display cLanciaStratos) (state final))))

(defrule result-childhood-posters
  (logical (who-are-you aChildhoodPosters))
  =>
  (assert (UI-state (display aChildhoodPosters) (state final))))

(defrule result-weird-fetish
  (logical (who-are-you aWeirdFetish))
  =>
  (assert (UI-state (display cSetWeirdFetish) (state final))))

;; soul
(defrule result-easy
  (logical (soul aEasy))
  =>
  (assert (UI-state (display cAmphicar) (state final))))

(defrule result-synonym
  (logical (soul aSynonym))
  =>
  (assert (UI-state (display cSetSynonym) (state final))))

(defrule result-honest-job
  (logical (soul aSoulHonestJob))
  =>
  (assert (UI-state (display cSetSoulHonestJob) (state final))))

(defrule result-car-starring
  (logical (soul aCarStarring))
  =>
  (assert (UI-state (display cSetCarStarring) (state final))))

(defrule result-pure-evil
  (logical (soul aPureEvil))
  =>
  (assert (UI-state (display cSetPureEvil) (state final))))

(defrule result-soul-is-the-spirit
  (logical (soul aSoulIsTheSpirit))
  =>
  (assert (UI-state (display cNashMetropolitan) (state final))))

(defrule result-lucas-electics
  (logical (soul aLucasElectrics))
  =>
  (assert (UI-state (display cVolvoP1800) (state final))))

;; fast-fwd-sofa
(defrule result-fast-fwd-sofa
  (logical (fast-fwd-sofa Yes))
  =>
  (assert (UI-state (display cOldsToronado) (state final))))

(defrule result-fast-fwd-sofa
  (logical (fast-fwd-sofa No))
  =>
  (assert (UI-state (display cLincolnTownCar) (state final))))


;; like what
(defrule result-pistons
  (logical (like-what aPistons))
  =>
  (assert (UI-state (display cMazdaRX7) (state final))))

(defrule result-engine-wrong-place
  (logical (like-what aEngineWrongPlace))
  =>
  (assert (UI-state (display cSetEngineWrongPlace) (state final))))

(defrule result-can-burn
  (logical (like-what aCanBurn))
  =>
  (assert (UI-state (display cMercedesBenz300TD) (state final))))

(defrule result-building-plane
  (logical (like-what aBuildingPlane))
  =>
  (assert (UI-state (display cSaab96) (state final))))


;;;*************************
;;;* GUI INTERACTION RULES *
;;;*************************

(defrule ask-question
   (declare (salience 5))
   (UI-state (id ?id))
   ?f <- (state-list (sequence $?s&:(not (member$ ?id ?s))))
   =>
   (modify ?f (current ?id)
              (sequence ?id ?s))
   (halt))

(defrule handle-next-no-change-none-middle-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id)
   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
   =>
   (retract ?f1)
   (modify ?f2 (current ?nid))
   (halt))

(defrule handle-next-response-none-end-of-chain
   (declare (salience 10))
   ?f <- (next ?id)
   (state-list (sequence ?id $?))
   (UI-state (id ?id) (relation-asserted ?relation))
   =>
   (retract ?f)
   (assert (add-response ?id)))

(defrule handle-next-no-change-middle-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id ?response)
   ?f2 <- (state-list (current ?id) (sequence $? ?nid ?id $?))
   (UI-state (id ?id) (response ?response))
   =>
   (retract ?f1)
   (modify ?f2 (current ?nid))
   (halt))

(defrule handle-next-change-middle-of-chain
   (declare (salience 10))
   (next ?id ?response)
   ?f1 <- (state-list (current ?id) (sequence ?nid $?b ?id $?e))
   (UI-state (id ?id) (response ~?response))
   ?f2 <- (UI-state (id ?nid))
   =>
   (modify ?f1 (sequence ?b ?id ?e))
   (retract ?f2))

(defrule handle-next-response-end-of-chain
   (declare (salience 10))
   ?f1 <- (next ?id ?response)
   (state-list (sequence ?id $?))
   ?f2 <- (UI-state (id ?id)
                    (response ?expected)
                    (relation-asserted ?relation))
   =>
   (retract ?f1)
   (if (neq ?response ?expected)
      then
      (modify ?f2 (response ?response)))
   (assert (add-response ?id ?response)))

(defrule handle-add-response
   (declare (salience 10))
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   ?f1 <- (add-response ?id ?response)
   =>
   (str-assert (str-cat "(" ?relation " " ?response ")"))
   (retract ?f1))

(defrule handle-add-response-none
   (declare (salience 10))
   (logical (UI-state (id ?id)
                      (relation-asserted ?relation)))
   ?f1 <- (add-response ?id)
   =>
   (str-assert (str-cat "(" ?relation ")"))
   (retract ?f1))

(defrule handle-prev
   (declare (salience 10))
   ?f1 <- (prev ?id)
   ?f2 <- (state-list (sequence $?b ?id ?p $?e))
   =>
   (retract ?f1)
   (modify ?f2 (current ?p))
   (halt))