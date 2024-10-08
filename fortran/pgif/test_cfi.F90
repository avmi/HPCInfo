module cfi
    implicit none
    interface
        subroutine foo(buffer,dims,ndim) bind(C,name="foo")
            class(*), dimension(*) :: buffer
            integer, dimension(*) :: dims
            integer, value :: ndim
        end subroutine foo
    end interface

    interface
        subroutine bar(buffer) bind(C,name="bar")
            ! NOTE: ignore_tkr(c) only causes a noncontiguous buffer to be passed
            !       when known-rank arrays are used.  assumed-rank arrays will be
            !       copied into a contiguous subarray.
            !pgi$ ignore_tkr(c) buffer
            class(*), dimension(:,:,:) :: buffer
            !class(*), dimension(..) :: buffer
            !integer, dimension(..) :: buffer
            !integer, dimension(:,:,:) :: buffer
        end subroutine bar
    end interface
end module cfi 

program test
    use iso_c_binding
    use cfi
    implicit none

#if 0
    integer(4), dimension(5,7,9) :: a
    integer(4), dimension(:,:,:), allocatable :: c
    integer :: i, j, k

    allocate( c(5,7,9) )

    do i=1,size(a,3)
      do j=1,size(a,2)
        do k=1,size(a,1)
          a(k,j,i) = 10*k + 10*100*j + 10*100*100*i
        end do
      end do
    end do
    c = a

    call foo(a,shape(a),size(shape(a)))
    print*,'================================'
    call bar(a)
    print*,'================================'
    call bar(c)
#endif

    block
        !integer(4), dimension(-2:2,-3:3,-4:4) :: q0
        !integer(4), dimension(-1:3,-2:4,-3:5) :: q1
        !integer(4), dimension( 0:4,-1:5,-2:6) :: q2
        !integer(4), dimension( 1:5, 0:6,-1:7) :: q3
        !integer(4), dimension( 2:6, 1:7, 0:8) :: q4
        integer(4), dimension(4,8,9) :: q5
        !print*,'================================'
        !call bar(q0)
        !print*,'================================'
        !call bar(q1)
        !print*,'================================'
        !call bar(q2)
        !print*,'================================'
        !call bar(q3)
        !print*,'================================'
        !call bar(q4)
        !print*,'================================'
        !call bar(q5)
        !print*,'================================'
        q5 = -1
        q5(1:4:2,1:8:2,1:9:3) = 1
        call bar(q5(1:4:2,1:8:2,1:9:3))
    end block

end program test
