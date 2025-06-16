from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import Annotated
from server.database import get_session
from server.models import Transaction
from server.schemas import TransactionIn

router = APIRouter()

@router.post("/users/me/transactions/")
async def create_transaction(
    tx: TransactionIn,
    session: Annotated[Session, Depends(get_session)]
):
    new_tx = Transaction(
        date=tx.date,
        amount=tx.amount,
        category=tx.category,
        description=tx.description,
    )
    session.add(new_tx)
    session.commit()
    session.refresh(new_tx)
    return new_tx

@router.get("/users/me/transactions/")
async def get_transactions(
    session: Annotated[Session, Depends(get_session)]
):
    return session.query(Transaction).all()
