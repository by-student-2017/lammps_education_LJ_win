PROGRAM BRUTEFORCE
IMPLICIT NONE
CHARACTER(LEN=256) :: trajectory_in="test.lmp"
CHARACTER(LEN=256) :: trajectory_out="test_sorted.lmp"
CHARACTER(LEN=256) :: inputstring
INTEGER,PARAMETER :: ion_pairs=512
INTEGER,PARAMETER :: cations=25
INTEGER,PARAMETER :: cationdrudes=10
INTEGER,PARAMETER :: anions=15
INTEGER,PARAMETER :: aniondrudes=9
CHARACTER(LEN=1) :: element(ion_pairs*(cations+anions+cationdrudes+aniondrudes))
REAL(KIND=KIND(1.0e0)) :: snapshot(ion_pairs*(cations+anions+cationdrudes+aniondrudes),3)
INTEGER :: stepcounter,n,atomcounter,molecule_counter,total_natoms
LOGICAL :: skip_step,traj_read
	CALL timing(.TRUE.)
	total_natoms=ion_pairs*(cations+anions+cationdrudes+aniondrudes)
	IF (COMMAND_ARGUMENT_COUNT()/=2) THEN
		PRINT *,"please provide input trajectory / output trajectory as arguments."
		STOP
	ENDIF
	CALL GET_COMMAND_ARGUMENT(1,trajectory_in)
	CALL GET_COMMAND_ARGUMENT(2,trajectory_out)
	OPEN(UNIT=3,FILE=TRIM(trajectory_in),ACTION="READ")
	OPEN(UNIT=9,FILE=TRIM(trajectory_out))
	WRITE(*,FMT='(" Converting ... ")')
	REWIND 3
	DO n=1,9,1
		READ(3,*)
	ENDDO
	CALL read_elements()
	REWIND 3
	stepcounter=1
	DO
		CALL head_transfer(skip_step,traj_read)
		IF (traj_read) THEN
			WRITE(*,*) "stopped at stepcounter ",stepcounter
			EXIT
		ENDIF
		CALL read_body()
		IF (.NOT.(skip_step)) THEN
			stepcounter=stepcounter+1
			CALL write_in_useful_format()
		ENDIF
	ENDDO
	WRITE(*,*)
	WRITE(*,*) "DONE"
	CLOSE(UNIT=3)
	CLOSE(UNIT=9)
	CALL timing(.FALSE.)
	CONTAINS

  SUBROUTINE timing(start)
  IMPLICIT NONE
  !$ INTERFACE
  !$  FUNCTION OMP_get_wtime()
  !$  REAL(8) :: OMP_get_wtime
  !$  END FUNCTION OMP_get_wtime
  !$ END INTERFACE
  LOGICAL :: start
  !$ REAL(8) :: clipboard_real
  !$ REAL(8),SAVE :: timeline_real=0.0d0
   !$ clipboard_real=OMP_get_wtime()
   !$ IF (start) THEN
   !$  timeline_real=clipboard_real
   !$ ELSE
   !$  IF (timeline_real>0.0d0) THEN
   !$   CALL user_friendly_time_output(clipboard_real-timeline_real)
   !$  ENDIF
   !$ ENDIF
  END SUBROUTINE timing

  SUBROUTINE user_friendly_time_output(seconds)
  IMPLICIT NONE
  REAL(8) :: seconds
  IF (seconds<(999.0d-6)) THEN
   WRITE(*,'(F5.1,A)') seconds*(1.0d6)," microseconds"
  ELSEIF (seconds<(999.0d-3)) THEN
   WRITE(*,'(F5.1,A)') seconds*(1.0d3)," milliseconds"
  ELSEIF (seconds>(86400.0d0)) THEN
   WRITE(*,'(F5.1,A)') seconds/(86400.0d0)," days"
  ELSEIF (seconds>(3600.0d0)) THEN
   WRITE(*,'(F5.1,A)') seconds/(3600.0d0)," hours"
  ELSEIF (seconds>(60.0d0)) THEN
   WRITE(*,'(F5.1,A)') seconds/(60.0d0)," minutes"
  ELSE
   WRITE(*,'(F5.1,A)') seconds," seconds"
  ENDIF
  END SUBROUTINE user_friendly_time_output

		SUBROUTINE read_body()
		IMPLICIT NONE
		INTEGER :: m,dummy
		CHARACTER(LEN=2) :: element_name
			DO m=1,total_natoms,1
				!READ(3,*) element(m),dummy,snapshot(m,:)
				READ(3,*) element_name,snapshot(m,:)
				IF (element_name/=element(m)) PRINT *,"ELEMENT NAME MISMATCH"
			ENDDO
		END SUBROUTINE read_body

		SUBROUTINE read_elements()
		IMPLICIT NONE
		INTEGER :: m
			DO m=1,total_natoms,1
				READ(3,*) element(m)
			ENDDO
		END SUBROUTINE read_elements

		SUBROUTINE write_in_useful_format()
		IMPLICIT NONE
	1	FORMAT (A1,3E14.6)
		INTEGER :: m,dummy,atomcounter
		CHARACTER(LEN=2) :: element_name
		!Write cations and its drudes
		DO molecule_counter=0,ion_pairs-1,1
			DO atomcounter=1,cations,1
				WRITE(9,1) element(molecule_counter*cations+atomcounter),snapshot(molecule_counter*cations+atomcounter,:)
			ENDDO
			DO atomcounter=1,cationdrudes,1
				WRITE(9,1) element(molecule_counter*cationdrudes+atomcounter+ion_pairs*(cations+anions)),&
				&snapshot(molecule_counter*cationdrudes+atomcounter+ion_pairs*(cations+anions),:)
			ENDDO
		ENDDO
		!Write anions and its drudes
		DO molecule_counter=0,ion_pairs-1,1
			DO atomcounter=1,anions,1
				WRITE(9,1) element(molecule_counter*anions+atomcounter+ion_pairs*(cations)),&
				&snapshot(molecule_counter*anions+atomcounter+ion_pairs*(cations),:)
			ENDDO
			DO atomcounter=1,aniondrudes,1
				WRITE(9,1) element(molecule_counter*aniondrudes+atomcounter+ion_pairs*(cations+anions+cationdrudes)),&
				&snapshot(molecule_counter*aniondrudes+atomcounter+ion_pairs*(cations+anions+cationdrudes),:)
			ENDDO
		ENDDO
		END SUBROUTINE write_in_useful_format

		SUBROUTINE skip(nlines)
		IMPLICIT NONE
		INTEGER :: m,nlines
			!WRITE(*,ADVANCE="NO",FMT='(" step ",I0," - molecule - ",I0)') stepcounter,molecule_counter
			!WRITE(*,'(" skipping ",I0," steps.")') nlines
			DO m=1,nlines,1
				READ(3,*)
			ENDDO
		END SUBROUTINE skip

		SUBROUTINE goback(nlines)
		IMPLICIT NONE
		INTEGER :: m,nlines
			!WRITE(*,ADVANCE="NO",FMT='(" step ",I0," - molecule - ",I0)') stepcounter,molecule_counter
			!WRITE(*,'(" rewinding ",I0," steps.")') nlines
			DO m=1,nlines,1
				BACKSPACE 3
			ENDDO
		END SUBROUTINE goback

		SUBROUTINE head_transfer(skip,done)
		IMPLICIT NONE
		REAL :: xlo,xhi,ylo,yhi,zlo,zhi
		INTEGER :: timestep,ios
		INTEGER,SAVE :: previous_timestep=-1,delta=-1
		LOGICAL :: skip,done
			done=.FALSE.
			skip=.FALSE.
			!WRITE(*,'(" Transferring header.")')
			READ(3,IOSTAT=ios,FMT=*)
			IF (ios/=0) THEN
				done=.TRUE.
				RETURN
			ENDIF
			READ(3,IOSTAT=ios,FMT=*) timestep
			IF (ios/=0) THEN
				done=.TRUE.
				RETURN
			ENDIF
			READ(3,*)
			READ(3,*) n
			READ(3,*)
			READ(3,*) xlo,xhi
			READ(3,*) ylo,yhi
			READ(3,*) zlo,zhi
			READ(3,*)
			!check timestep item for consistency
			IF ((previous_timestep+delta)/=timestep) THEN
				!delta doesn't match
				IF (previous_timestep>=0) THEN
					IF (delta>0) THEN
						!delta and previous_timestep have been initialised, but don't match...
						!...there must have been an issue!
						skip=.TRUE.
						WRITE(*,'(" Ignored timestep ",I0,", at counter ",I0,".")') timestep,stepcounter
						WRITE(*,'(" (previous ",I0," / current ",I0," / delta ",I0,")")') previous_timestep,timestep,delta
					ELSE
						!initialise delta and go on
						delta=timestep-previous_timestep
						WRITE(*,'(" delta has been initialised to ",I0)') delta
					ENDIF
				ELSE
					!initialise previous_timestep and go on
					previous_timestep=timestep
				ENDIF
			ENDIF
			!Here's the checkpoint!
			IF (skip) RETURN
			!previous_timestep is updated after the checkpoint.
			!Thus, converting only continues after the current timestep matches again.
			previous_timestep=timestep
			WRITE(9,'("ITEM: TIMESTEP")')
			WRITE(9,'(I0)') timestep
			WRITE(9,'("ITEM: NUMBER OF ATOMS")')
			WRITE(9,'(I0)') n
			WRITE(9,'("ITEM: BOX BOUNDS pp pp pp")')
			WRITE(9,*) xlo,xhi
			WRITE(9,*) ylo,yhi
			WRITE(9,*) zlo,zhi
			WRITE(9,'("ITEM: ATOMS element xu yu zu")')
		END SUBROUTINE head_transfer

		SUBROUTINE atom_transfer(natoms)
		IMPLICIT NONE
		REAL :: x,y,z
		INTEGER natoms
			!WRITE(*,ADVANCE="NO",FMT='(" step ",I0," - molecule - ",I0)') stepcounter,molecule_counter
			!WRITE(*,'(" transferring ",I0," atoms.")') natoms
			DO atomcounter=1,natoms,1
				READ(3,*) element,x,y,z
				WRITE(9,*) element,x,y,z
			ENDDO
		END SUBROUTINE atom_transfer
END
