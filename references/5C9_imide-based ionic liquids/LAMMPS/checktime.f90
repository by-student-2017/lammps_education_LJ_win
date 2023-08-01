

PROGRAM checktime
IMPLICIT NONE
INTEGER :: lines,ios,time,difference,previous
CHARACTER(LEN=1024) :: filename
	CALL GET_COMMAND_ARGUMENT(1,filename)
	OPEN(UNIT=9,FILE=TRIM(filename))
	READ(9,*)
	lines=0
	time=0
	difference=0
	previous=0
	READ(9,IOSTAT=ios,FMT=*) previous
	READ(9,IOSTAT=ios,FMT=*) time
	difference=time-previous
	previous=time
	WRITE(*,'("Time difference initialised to ",I0)')difference
	DO
		READ(9,IOSTAT=ios,FMT=*) time
		IF (ios/=0) THEN
			WRITE(*,'(" Read ",I0," lines.")')lines
			EXIT
		ENDIF
		IF (time==previous) THEN
			WRITE(*,'(" double step at ",I0)') time
		ELSEIF ((time-previous)/=difference) THEN
			WRITE(*,'(" Mismatch: ",I0,", after step ",I0)') time-previous,previous
		ENDIF
		!difference=time-previous
		previous=time
		lines=lines+1
	ENDDO
	CLOSE(UNIT=9)
END PROGRAM